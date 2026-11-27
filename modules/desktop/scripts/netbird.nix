# NetBird: state for the bar, fzf menu (connect, disconnect, exit node) and launcher actions
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      config,
      lib,
      pkgs,
      osConfig,
      scripts,
      ...
    }: let
      client = osConfig.services.netbird.clients.default;
      nb = "${client.wrapper}/bin/netbird";
      path = lib.makeBinPath (with pkgs; [coreutils gawk jq]);
      osd = "${scripts.osd}/bin/osd";

      # Select one exit node (replacing the other exit nodes, keeping the other networks), or none
      setExit = ''
        set_exit() {
          local others
          others=$(${scripts.netbird-exits} | awk -F'\t' -v id="''${1:-}" '$2 == 1 && $1 != id { print $1 }')
          if [ -n "$others" ]; then
            # shellcheck disable=SC2086
            ${nb} networks deselect $others >/dev/null
          fi
          if [ -n "''${1:-}" ]; then
            ${nb} networks select --append "$1" >/dev/null
            ${osd} "󰇧  Exit node: $1" netbird
          else
            ${osd} "󰇧  No exit node" netbird
          fi
        }
      '';
    in
      lib.mkIf (osConfig.services.netbird.clients ? default) {
        # Exit nodes (routes to 0.0.0.0/0 or ::/0): id \t selected (1 or 0)
        scripts.netbird-exits = pkgs.writeShellScript "netbird-exits" ''
          export PATH=${path}:$PATH
          timeout 2 ${nb} networks list 2>/dev/null | awk '
            /^  - ID: / { id = substr($0, 9); net = "" }
            # Network is a list: "0.0.0.0/0, ::/0"
            /^    Network: / { net = ", " substr($0, 14) "," }
            /^    Status: / && (net ~ /, 0\.0\.0\.0\/0,/ || net ~ /, ::\/0,/) { print id "\t" ($2 == "Selected") }
          ' | sort -u
        '';

        # state (up, down, logout) \t selected exit nodes (comma separated); fails without daemon
        scripts.netbird-state = pkgs.writeShellScript "netbird-state" ''
          export PATH=${path}:$PATH
          [ -S ${client.dir.runtime}/sock ] || exit 1
          status=$(timeout 2 ${nb} status --json 2>/dev/null | jq -r '.daemonStatus // empty')
          case $status in
            "") exit 1 ;;
            Connected) state=up ;;
            NeedsLogin | LoginFailed | SessionExpired) state=logout ;;
            *) state=down ;;
          esac
          exit=""
          [ $state = up ] && exit=$(${scripts.netbird-exits} | awk -F'\t' '$2 == 1 { print $1 }' | paste -sd,)
          printf '%s\t%s\n' "$state" "$exit"
        '';

        scripts.netbird-toggle = pkgs.writeShellApplication {
          name = "netbird-toggle";
          runtimeInputs = [pkgs.coreutils];
          text = ''
            IFS=$'\t' read -r state _ < <(${scripts.netbird-state}) || exit 1
            case $state in
              up) ${nb} down >/dev/null && ${osd} "󰒍  NetBird Down" netbird ;;
              down) ${nb} up >/dev/null && ${osd} "󰒍  NetBird Up" netbird ;;
              logout) exec ${scripts.term}/bin/term ${scripts.netbird-menu}/bin/netbird-menu ;; # SSO login needs a terminal
            esac
          '';
        };

        scripts.netbird-exit-off = pkgs.writeShellApplication {
          name = "netbird-exit-off";
          runtimeInputs = with pkgs; [coreutils gawk];
          text = ''
            ${setExit}
            set_exit ""
          '';
        };

        # fzf menu; `netbird-menu exit` lists only the exit nodes
        scripts.netbird-menu = pkgs.writeShellApplication {
          name = "netbird-menu";
          runtimeInputs = with pkgs; [coreutils gawk fzf];
          text = ''
            # Session variables (FZF_DEFAULT_OPTS...): only zsh loads them, not a terminal started from the bar
            # shellcheck disable=SC1091
            . ${config.environment.loadEnv}

            ${setExit}

            pause() {
              printf '\n\e[2m%s\e[0m' "Press a key to close"
              read -rsn1 _ || true
            }

            mode=''${1:-}
            if ! IFS=$'\t' read -r state _ < <(${scripts.netbird-state}); then
              echo "NetBird daemon is not running"
              pause
              exit 1
            fi

            # action \t argument (- if none) \t label
            entries=()
            if [ "$mode" != exit ]; then
              case $state in
                up) entries+=($'down\t-\t󰅛 Disconnect') ;;
                down) entries+=($'up\t-\t󰐥 Connect') ;;
                logout) entries+=($'login\t-\t󰍂 Log in') ;;
              esac
            fi
            if [ "$state" = up ]; then
              active=""
              while IFS=$'\t' read -r id selected; do
                if [ "$selected" = 1 ]; then
                  active=1
                  entries+=("exit"$'\t'"$id"$'\t'"󰇧 $id  (active)")
                else
                  entries+=("exit"$'\t'"$id"$'\t'"󰇧 $id")
                fi
              done < <(${scripts.netbird-exits})
              [ -n "$active" ] && entries+=($'noexit\t-\t󰈆 No exit node')
            fi
            if [ ''${#entries[@]} -eq 0 ]; then
              echo "NetBird is not connected"
              pause
              exit 0
            fi

            choice=$(printf '%s\n' "''${entries[@]}" | fzf --delimiter=$'\t' --with-nth=3) || exit 0
            IFS=$'\t' read -r action arg label <<<"$choice"
            case $action in
              up) ${nb} up >/dev/null && ${osd} "󰒍  NetBird Up" netbird ;;
              down) ${nb} down >/dev/null && ${osd} "󰒍  NetBird Down" netbird ;;
              login)
                ${nb} up && ${osd} "󰒍  NetBird Up" netbird
                pause
                ;;
              # Choosing the active exit node turns it off
              exit) if [[ $label == *"(active)" ]]; then set_exit ""; else set_exit "$arg"; fi ;;
              noexit) set_exit "" ;;
            esac
          '';
        };

        launcher = {
          netbird-toggle.name = "NetBird: Connect/Disconnect";
          netbird-menu = {
            name = "NetBird";
            exec = "${scripts.term}/bin/term ${scripts.netbird-menu}/bin/netbird-menu";
          };
          netbird-exit = {
            name = "NetBird: Choose Exit Node";
            exec = "${scripts.term}/bin/term ${scripts.netbird-menu}/bin/netbird-menu exit";
          };
          netbird-exit-off.name = "NetBird: Disable Exit Node";
        };
      })
  ];
}
