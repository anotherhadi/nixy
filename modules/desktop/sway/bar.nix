# Swaybar: sway's built-in bar (waybar stays on Hyprland). Workspaces and tray
# are swaybar's; the rest comes from `swaybar-status`, an i3bar-protocol script
# with the same blocks and clicks as waybar, and the shared OSD.
{config, ...}: let
  inherit (config) theme;
  c = theme.colors;
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      osConfig,
      scripts,
      ...
    }: let
      settuings = page: "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs.nur.repos.anotherhadi.settuings}/bin/settuings --page ${page}";

      status = pkgs.writeShellScriptBin "swaybar-status" ''
        export PATH=${lib.makeBinPath (with pkgs; [coreutils gawk gnugrep jq procps systemd wireplumber])}:$PATH
        export TZ=${osConfig.time.timeZone}

        battery() {
          for bat in /sys/class/power_supply/BAT*; do
            [ -r "$bat/capacity" ] || continue
            local cap icons=($'' $'' $'' $'' $'')
            cap=$(cat "$bat/capacity")
            local icon=''${icons[$((cap * 5 / 101))]}
            if [ "$(cat "$bat/status")" = Charging ]; then
              printf '%s %s %s%%' $'' "$icon" "$cap"
            else
              printf '%s %s%%' "$icon" "$cap"
            fi
            return
          done
        }

        volume() {
          local raw vol
          raw=$(wpctl get-volume @DEFAULT_SINK@ 2>/dev/null) || return
          vol=$(printf '%s' "$raw" | awk '{printf "%d", $2*100}')
          if [[ $raw == *MUTED* ]]; then printf '%s' $'\U000f075f'
          elif [ "$vol" -lt 33 ]; then printf '%s' $'\U000f057f'
          elif [ "$vol" -lt 66 ]; then printf '%s' $'\U000f0580'
          else printf '%s' $'\U000f057e'
          fi
        }

        # One line of blocks: "name<TAB>text" in, i3bar JSON out
        render() {
          {
            osd=$(${scripts.waybar-osd-status}/bin/waybar-osd-status) && printf 'osd\t%s\n' "$osd"
            printf 'clock\t%s\n' "$(date +%H:%M)"
            [ -n "$network" ] && printf 'network\t%s\n' "$network"
            [ -n "$bluetooth" ] && printf 'bluetooth\t%s\n' "$bluetooth"
            bat=$(battery) && [ -n "$bat" ] && printf 'battery\t%s\n' "$bat"
            vol=$(volume) && [ -n "$vol" ] && printf 'volume\t%s\n' "$vol"
            systemctl --user is-active --quiet hypridle 2>/dev/null || printf 'caffeine\t%s\n' $'\U000f0176'
          } | jq -Rnc '[inputs | split("\t") | {name: .[0], full_text: .[1], markup: "pango", separator: false, separator_block_width: 16}]'
        }

        # Blocks, every second (slow ones less often) or right away on RTMIN+8 (OSD, clicks)
        loop() {
          trap : RTMIN+8
          local tick=0
          while :; do
            printf '%s,\n' "$(render)"
            # Slow probes after drawing, so the bar shows up right away
            if [ $((tick % 10)) -eq 0 ]; then
              network=$(${scripts.networkScript} | jq -r .text)
              # bluetoothctl waits forever without bluetoothd (hosts without the bluetooth aspect)
              bluetooth=$(timeout 1 ${pkgs.bluez}/bin/bluetoothctl list 2>/dev/null | grep -q Controller && ${scripts.bluetoothScript} | jq -r .text)
            fi
            tick=$((tick + 1))
            sleep 1 &
            wait $! 2>/dev/null
          done
        }

        # Ignored here (it would cut `read` short), handled by the loop
        trap "" RTMIN+8
        printf '%s\n[\n' '{"version": 1, "click_events": true}'
        loop &
        loop_pid=$!
        trap 'kill $loop_pid' EXIT # swaybar closed stdin

        # Clicks from swaybar: one JSON object per line, after a "[" and with leading commas
        while read -r line; do
          line=''${line#,}
          [ "$line" = "[" ] && continue
          read -r name button < <(printf '%s' "$line" | jq -r '"\(.name) \(.button)"')
          case "$name:$button" in
            network:1) ${settuings "network"} & ;;
            bluetooth:1) ${settuings "bluetooth"} & ;;
            battery:1) ${settuings "power"} & ;;
            volume:1) ${settuings "audio"} & ;;
            volume:3) ${scripts.vol-mute}/bin/vol-mute ;;
            volume:4) ${scripts.vol-up}/bin/vol-up ;;
            volume:5) ${scripts.vol-down}/bin/vol-down ;;
            caffeine:1) ${scripts.caffeine-toggle}/bin/caffeine-toggle ;;
          esac
        done
      '';
    in {
      packages = [status];

      sway.config = ''
        bar {
          position top
          status_command ${status}/bin/swaybar-status
          font pango:${theme.fonts.sansSerif} Bold ${toString theme.fonts.sizes.applications}
          height ${toString theme.bar-height}
          status_padding 0
          status_edge_padding 14
          tray_padding 4
          workspace_min_width ${toString theme.bar-height}
          colors {
            background #${c.base01}
            statusline #${c.base05}
            separator  #${c.base03}
            # class            border       background   text
            focused_workspace  #${c.base0D} #${c.base0D} #${c.base00}
            active_workspace   #${c.base02} #${c.base02} #${c.base05}
            inactive_workspace #${c.base01} #${c.base01} #${c.base05}
            urgent_workspace   #${c.base08} #${c.base08} #${c.base00}
            binding_mode       #${c.base0A} #${c.base0A} #${c.base00}
          }
        }
      '';
    })
  ];
}
