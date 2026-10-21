# veille-vulnx: watch new CVEs of the technologies listed in a watchlist, with vulnx
# Reports each CVE never seen before (stdout, daily report, and the watchlist's on_match command)
# Data in ~/.local/state/veille-vulnx (already persisted): watchlist.yaml (edited by hand), seen.txt, reports/
# Runs once per boot, when the graphical session is up, retrying until online
{aspects, ...}: {
  flake.modules.nixos.veille-vulnx = {
    imports = [
      aspects.hjem
      aspects.signal-notify # used by the default on_match
    ];

    hjem.extraModules = [
      ({pkgs, ...}: let
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

                # Values passed as environment variables, not substituted in the
                # command: a CVE name cannot inject anything
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

        # Once per boot: skipped when the last successful run happened during this boot
        boot-stamp = pkgs.writeShellScript "veille-vulnx-boot-stamp" ''
          # check|write STAMP_FILE
          boot_id=$(${pkgs.coreutils}/bin/cat /proc/sys/kernel/random/boot_id)
          case "$1" in
            check) [ "$(${pkgs.coreutils}/bin/cat "$2" 2>/dev/null)" != "$boot_id" ] ;;
            write) echo "$boot_id" >"$2" ;;
          esac
        '';
        stamp = "%S/veille-vulnx/.boot-id"; # %S: ~/.local/state
      in {
        packages = [veille-vulnx];

        systemd.services.veille-vulnx = {
          description = "Watch new CVEs of the vulnx watchlist";
          after = ["graphical-session.target"];
          wantedBy = ["graphical-session.target"];
          startLimitIntervalSec = 0; # Keep retrying while offline
          serviceConfig = {
            Type = "oneshot";
            ExecCondition = "${boot-stamp} check ${stamp}";
            ExecStart = "${veille-vulnx}/bin/veille-vulnx";
            ExecStartPost = "${boot-stamp} write ${stamp}";
            Restart = "on-failure";
            RestartSec = "5min";
          };
        };
      })
    ];
  };
}
