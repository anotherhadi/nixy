# veille-vulnx: watch new CVEs of the technologies listed in a watchlist, with vulnx
# Check logs: `journalctl -u veille-vulnx`
# Check reports: `ls ~/.local/state/veille-vulnx/reports`
{aspects, ...}: {
  flake.modules.nixos.veille-vulnx = {
    config,
    pkgs,
    ...
  }: let
    username = config.nixy.username;
    home = config.users.users.${username}.home;

    watchlist-example = pkgs.writeText "watchlist.yaml" ''
      # Command run for each new CVE (optional).
      # Variables: $TECH $SEEN_ON $CVE $SEVERITY $CVSS $NAME $MESSAGE
      on_match: 'signal-notify "$MESSAGE"'

      # Technologies to watch, and where I saw them (a string or a list).
      targets: []
      #  - tech: "geoserver"
      #    seen_on:
      #      - "geo.example.com"
    '';

    veille-vulnx = pkgs.writeShellApplication {
      name = "veille-vulnx";
      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
        jq
        util-linux
        yq-go
        unstable.vulnx
      ];
      text = ''
        state="''${XDG_STATE_HOME:-$HOME/.local/state}/veille-vulnx"
        WATCHLIST="$state/watchlist.yaml"
        SEEN="$state/seen.txt" # "<tech> <cve_id>" already reported
        REPORT="$state/reports/$(date +%F).txt"

        mkdir -p "$state/reports"
        touch "$SEEN"

        exec 9>"$state/.lock"
        flock -n 9 || { echo "veille-vulnx already running" >&2; exit 0; }

        if [[ ! -e "$WATCHLIST" ]]; then
          install -m 644 ${watchlist-example} "$WATCHLIST"
          echo "No watchlist yet, example written to $WATCHLIST" >&2
          exit 0
        fi

        # Set on network or on_match failure: exit non-zero so the service retries,
        # CVEs not reported stay unseen until then
        failed=0

        on_match=$(yq '.on_match // ""' "$WATCHLIST")

        count=$(yq '.targets | length' "$WATCHLIST")
        for ((i = 0; i < count; i++)); do
          tech=$(yq ".targets[$i].tech" "$WATCHLIST")
          # seen_on is a string or a list
          seen_on=$(yq ".targets[$i].seen_on // [] | [] + . | join(\", \")" "$WATCHLIST")

          # vulnx prints nothing (exit 0) without results, and exits 1 when offline
          if ! json=$(vulnx search --silent --disable-update-check --json -n 100 \
            --vuln-status new "$tech"); then
            echo "vulnx failed for $tech" >&2
            failed=1
            continue
          fi
          [[ -z "$json" ]] && continue

          while IFS=$'\t' read -r cve severity score name; do
            grep -qxF "$tech $cve" "$SEEN" && continue

            msg="[$tech @ $seen_on] $cve ($severity, cvss $score) $name"
            echo "$msg" | tee -a "$REPORT"

            if [[ -n "$on_match" ]] && ! TECH="$tech" SEEN_ON="$seen_on" CVE="$cve" \
              SEVERITY="$severity" CVSS="$score" NAME="$name" MESSAGE="$msg" \
              bash -c "$on_match" </dev/null; then
              echo "on_match failed for $cve" >&2
              failed=1
              continue
            fi
            echo "$tech $cve" >>"$SEEN"
          done < <(jq -r '.results[] | select(.cve_id)
            | [.cve_id, (.severity // "?"), (.cvss_score // "?"), (.name // "")] | @tsv' <<<"$json")
        done

        exit "$failed"
      '';
    };
  in {
    imports = [
      aspects.signal-notify # used by the default on_match
    ];

    environment.systemPackages = [veille-vulnx];

    systemd.services.veille-vulnx = {
      description = "Watch new CVEs of the vulnx watchlist";
      after = ["network-online.target"];
      wants = ["network-online.target"];
      # on_match commands (signal-notify...) come from the system profile
      path = ["/run/current-system/sw"];
      environment.HOME = home;
      serviceConfig = {
        Type = "oneshot";
        User = username;
        ExecStart = "${veille-vulnx}/bin/veille-vulnx";
      };
    };

    # A failed run (offline, on_match error) is retried on the next tick:
    # unreported CVEs stay unseen until then
    systemd.timers.veille-vulnx = {
      description = "Hourly CVE watch with vulnx";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "1h";
        Persistent = true;
      };
    };
  };
}
