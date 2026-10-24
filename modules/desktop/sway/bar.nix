# Swaybar: sway's built-in bar
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
      settuings = page: "${scripts.term}/bin/term ${pkgs.nur.repos.anotherhadi.settuings}/bin/settuings --page ${page}";

      status = pkgs.writeShellScriptBin "swaybar-status" ''
        export PATH=${lib.makeBinPath (with pkgs; [coreutils jq procps])}:$PATH

        # Blocks as i3bar JSON, in badges
        render() {
          BLUETOOTH="$bluetooth" ${scripts.status-blocks} | jq -Rnc '
            ${badge}
            [inputs | split("\t") | {name: .[0], full_text: (.[2] as $bg | .[1] | badge($bg)), markup: "pango", separator: false, separator_block_width: 8}]'
        }

        # Blocks, every second (slow ones less often) or right away on RTMIN+8 (OSD, clicks)
        loop() {
          trap : RTMIN+8
          local tick=0
          while :; do
            printf '%s,\n' "$(render)"
            # bluetoothctl is slow: after drawing, every 5s
            [ $((tick % 5)) -eq 0 ] && bluetooth=$(${scripts.status-blocks} bluetooth)
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
            mic:1 | camera:1 | screen:1) ${scripts.term}/bin/term ${scripts.privacy-who}/bin/privacy-who & ;;
          esac
        done
      '';
      # Badge (pill) around each block's text: Nerd Font half circles around its color
      badge = ''def badge($bg): "<span color=\"#\($bg)\"></span><span background=\"#\($bg)\" color=\"#${c.base00}\"> \(.) </span><span color=\"#\($bg)\"></span>";'';
    in {
      scripts.status-blocks = pkgs.writeShellScript "status-blocks" ''
        export PATH=${lib.makeBinPath (with pkgs; [coreutils gawk gnugrep gnused jq playerctl procps systemd wireplumber])}:$PATH
        export TZ=${osConfig.time.timeZone}

        network() {
          local dev q eth="" wifi="" vpn="" color=${c.base04} off='󰤭'
          local signal=('󰤟' '󰤢' '󰤥' '󰤨')
          for dev in /sys/class/net/*; do
            case ''${dev##*/} in
              tun* | wg* | proton* | ppp*) vpn=" 󰖂" color=${c.base0C}; continue ;;
            esac
            [ -e "$dev/device" ] && [ "$(cat "$dev/operstate")" = up ] || continue
            if [ -d "$dev/wireless" ]; then
              q=$(awk -v i="''${dev##*/}:" '$1 == i { print int($3) }' /proc/net/wireless)
              wifi=''${signal[''${q:-0} * 4 / 71]} # link quality is out of 70
            else
              eth='󰈀'
            fi
          done
          [ -n "$eth" ] || eth=''${wifi:-$off}
          printf '%s%s\t%s' "$eth" "$vpn" "$color"
        }

        bluetooth() {
          [ -n "$(ls /sys/class/bluetooth 2>/dev/null)" ] || return
          local bt="timeout 2 ${pkgs.bluez}/bin/bluetoothctl"
          if ! $bt show 2>/dev/null | grep -q 'Powered: yes'; then
            printf '%s\t${c.base04}' '󰂲'
          elif [ -n "$($bt devices Connected 2>/dev/null)" ]; then
            printf '%s\t${c.base0D}' '󰂱'
          else
            printf '%s\t${c.base04}' '󰂯'
          fi
        }

        battery() {
          local bat cap icons=('󰁺' '󰁼' '󰁾' '󰂀' '󰂂' '󰁹')
          for bat in /sys/class/power_supply/BAT*; do
            [ -r "$bat/capacity" ] || continue
            cap=$(cat "$bat/capacity")
            if [ "$(cat "$bat/status")" = Charging ]; then
              printf '%s %s%%' '󰂄' "$cap"
            elif [ "$cap" -le 15 ]; then
              printf '%s %s%%' "''${icons[0]}" "$cap"
            else
              printf '%s %s%%' "''${icons[cap / 20]}" "$cap"
            fi
            return
          done
        }

        volume() {
          local raw vol
          raw=$(wpctl get-volume @DEFAULT_SINK@ 2>/dev/null) && [ -n "$raw" ] || return
          vol=$(printf '%s' "$raw" | awk '{printf "%d", $2*100}')
          if [[ $raw == *MUTED* ]]; then printf '%s' '󰝟'
          elif [ "$vol" -lt 33 ]; then printf '%s' '󰕿'
          elif [ "$vol" -lt 66 ]; then printf '%s' '󰖀'
          else printf '%s' '󰕾'
          fi
        }

        playing() {
          local artist title text
          IFS=$'\x1f' read -r artist title < <(playerctl -a metadata --format $'{{status}}\x1f{{artist}}\x1f{{title}}' 2>/dev/null \
            | awk -F'\x1f' '$1 == "Playing" { print $2 "\x1f" $3; exit }')
          [ -n "$title" ] || return
          text="''${artist:+$artist – }$title"
          [ ''${#text} -gt 40 ] && text="''${text:0:39}…"
          printf '%s' "$text" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'
        }

        if [ "''${1:-}" = bluetooth ]; then
          bluetooth
          exit
        fi

        # Privacy: whatever is using the mic, the camera or the screen
        privacy=$(${scripts.privacy-users} | cut -f1)
        grep -qx mic <<<"$privacy" && printf 'mic\t%s\t${c.base08}\n' '󰍬'
        grep -qx camera <<<"$privacy" && printf 'camera\t%s\t${c.base08}\n' '󰄀'
        grep -qx screen <<<"$privacy" && printf 'screen\t%s\t${c.base08}\n' '󰹑'
        osd=$(${scripts.osd-status}/bin/osd-status) && printf 'osd\t%s\t${c.base05}\n' "$osd"
        systemctl --user is-active --quiet swayidle 2>/dev/null || printf 'caffeine\t%s\t${c.base09}\n' '󰅶'
        bt=''${BLUETOOTH-$(bluetooth)}
        [ -n "$bt" ] && printf 'bluetooth\t%s\n' "$bt"
        printf 'network\t%s\n' "$(network)"
        if vol=$(volume) && [ -n "$vol" ]; then
          np=$(playing) && [ -n "$np" ] && vol="$vol  $np"
          printf 'volume\t%s\t${c.base0A}\n' "$vol"
        fi
        if bat=$(battery) && [ -n "$bat" ]; then
          cap=''${bat##* } && cap=''${cap%\%}
          color=${c.base0B}
          if [ "$cap" -le 15 ] && [[ $bat != '󰂄'* ]]; then
            color=${c.base08}
            pad=$(printf '%*s' $((20 + (15 - cap) * 4)) "")
            bat="$pad$bat$pad"
          fi
          printf 'battery\t%s\t%s\n' "$bat" "$color"
        fi
        printf 'clock\t%s\t${c.base0E}\n' "$(date +%H:%M)"
      '';

      scripts.status-pills = pkgs.writeShellScript "status-pills" ''
        ${scripts.status-blocks} | ${pkgs.gnugrep}/bin/grep -Ev $'^(osd|caffeine)\t' \
          | ${pkgs.jq}/bin/jq -nRrj '${badge} [inputs | split("\t") | .[2] as $bg | .[1] | badge($bg)] | join(" ")'
      '';

      packages = [status];

      sway.config = ''
        bar {
          position top
          status_command ${status}/bin/swaybar-status
          font pango:${theme.fonts.monospace} Bold ${toString theme.fonts.sizes.applications}
          height ${toString theme.bar-height}
          status_padding 0
          status_edge_padding 14
          tray_output none
          workspace_min_width ${toString theme.bar-height}
          colors {
            background #${c.base00}
            statusline #${c.base05}
            separator  #${c.base03}
            # class            border       background   text
            focused_workspace  #${c.base0D} #${c.base0D} #${c.base00}
            active_workspace   #${c.base02} #${c.base02} #${c.base05}
            inactive_workspace #${c.base01} #${c.base01} #${c.base05}
            urgent_workspace   #${c.base08} #${c.base08} #${c.base00}
            binding_mode       #${c.base0D} #${c.base0D} #${c.base00}
          }
        }
      '';
    })
  ];
}
