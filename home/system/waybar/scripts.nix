{
  pkgs,
  config,
}: let
  waybar-osd = pkgs.writeShellApplication {
    name = "waybar-osd";
    runtimeInputs = with pkgs; [procps coreutils];
    text = ''
      printf '%s' "$1" > "$XDG_RUNTIME_DIR/waybar-osd"
      pkill -f -RTMIN+8 '^waybar$' 2>/dev/null || true
    '';
  };

  waybar-osd-status = pkgs.writeShellApplication {
    name = "waybar-osd-status";
    runtimeInputs = with pkgs; [coreutils];
    text = ''
      file="$XDG_RUNTIME_DIR/waybar-osd"
      [ -f "$file" ] || exit 1
      mtime=$(stat -c %Y "$file" 2>/dev/null) || exit 1
      age=$(( $(date +%s) - mtime ))
      if [ "$age" -ge 3 ]; then
        rm -f "$file"
        exit 1
      fi
    '';
  };

  # battery-monitor: low-battery alerts, run by the systemd user timer.
  battery-monitor = pkgs.writeShellApplication {
    name = "battery-monitor";
    runtimeInputs = with pkgs; [waybar-osd libnotify glib coreutils];
    text = builtins.readFile ./battery-monitor.sh;
  };

  updateOsd = ''
    ${waybar-osd}/bin/waybar-osd "$OSD_TEXT"
  '';

  volGetText = ''
    VOL_RAW=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_SINK@)
    VOL=$(printf '%s' "$VOL_RAW" | awk '{printf "%d", $2*100}')
    if printf '%s' "$VOL_RAW" | grep -q MUTED; then
      OSD_TEXT="󰝟  $VOL%"
    elif [ "$VOL" -lt 33 ]; then
      OSD_TEXT="󰕿  $VOL%"
    elif [ "$VOL" -lt 66 ]; then
      OSD_TEXT="󰖀  $VOL%"
    else
      OSD_TEXT="󰕾  $VOL%"
    fi
  '';

  brightGetText = ''
    BRIGHT=$(${pkgs.brightnessctl}/bin/brightnessctl -m | awk -F, '{print int($5)}')
    if [ "$BRIGHT" -lt 33 ]; then
      OSD_TEXT="󰃞  $BRIGHT%"
    elif [ "$BRIGHT" -lt 66 ]; then
      OSD_TEXT="󰃟  $BRIGHT%"
    else
      OSD_TEXT="󰃠  $BRIGHT%"
    fi
  '';

  # Resolve $src: the default source, otherwise the first available source.
  # Some machines have no default audio source (@DEFAULT_AUDIO_SOURCE@ unresolved).
  micSource = ''
    src=$(${pkgs.wireplumber}/bin/wpctl inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | sed -n 's/^id \([0-9]*\),.*/\1/p')
    if [ -z "$src" ]; then
      src=$(${pkgs.pipewire}/bin/pw-dump | ${pkgs.jq}/bin/jq -r \
        '[.[] | select(.info.props."media.class"=="Audio/Source") | .id] | .[0] // empty')
    fi
  '';

  # tofi in vertical dmenu mode: the global config is a 36px-tall horizontal
  # launcher, unusable for a list, so override the geometry here.
  tofiMenu = "${pkgs.tofi}/bin/tofi --horizontal false --anchor center --width 700 --height 500 --margin-top 0 --margin-left 0 --margin-right 0 --num-results 10";

  # Name -> glyph table maintained by the nerd-fonts project itself, pinned to
  # the same release as the nerd-fonts packages in nixos/fonts.nix.
  nerdFontGlyphnames = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.4.0/glyphnames.json";
    sha256 = "sha256-4tENI/W/8L1vBnbpsB2XifzcZW3ntJiilVwncW6kQ5w=";
  };
  nerdFontIconList = pkgs.runCommand "nerd-font-icons.txt" {nativeBuildInputs = [pkgs.jq];} ''
    jq -r 'to_entries[] | select(.key != "METADATA") | "\(.value.char)  \(.key)"' \
      ${nerdFontGlyphnames} > "$out"
  '';
  osdPath = "$XDG_RUNTIME_DIR/waybar-osd";
in {
  inherit waybar-osd waybar-osd-status battery-monitor osdPath;

  bluetoothScript = pkgs.writeShellScript "waybar-bluetooth" ''
    jq=${pkgs.jq}/bin/jq
    nl=$'\n'
    # bluetoothctl hangs without a controller by default → always bounded by timeout.
    bt() { timeout 3 ${pkgs.bluez}/bin/bluetoothctl "$@" 2>/dev/null; }

    powered=$(bt show | awk '/Powered:/ { print $2; exit }')
    if [ "$powered" != "yes" ]; then
      "$jq" -cn '{ text: "󰂲", class: "off", tooltip: "Bluetooth off" }'
      exit 0
    fi

    tip=""
    add_tip() { tip="''${tip:+$tip$nl}$1"; }

    count=0
    for mac in $(bt devices Connected | awk '{ print $2 }'); do
      count=$((count + 1))
      info=$(bt info "$mac")
      name=$(printf '%s' "$info" | sed -n 's/^[[:space:]]*Name: //p' | head -1)
      [ -z "$name" ] && name="$mac"
      batt=$(printf '%s' "$info" | sed -n 's/.*Battery Percentage:.*(\([0-9][0-9]*\)).*/\1/p' | head -1)
      add_tip "󰂱  $name''${batt:+  ·  $batt%}"
    done

    if [ "$count" -gt 0 ]; then
      "$jq" -cn --arg tooltip "$tip" '{ text: "󰂰", class: "connected", tooltip: $tooltip }'
    else
      "$jq" -cn '{ text: "󰂰", class: "on", tooltip: "Bluetooth on" }'
    fi
  '';

  networkScript = pkgs.writeShellScript "waybar-network" ''
    nmcli=${pkgs.networkmanager}/bin/nmcli
    ip=${pkgs.iproute2}/bin/ip
    jq=${pkgs.jq}/bin/jq
    nl=$'\n'

    text=""
    tip=""
    class="disconnected"
    add_seg() { text="''${text:+$text }$1"; }
    add_tip() { tip="''${tip:+$tip$nl}$1"; }

    # ── Ethernet ────────────────────────────────────────────────
    eth=$("$nmcli" -t -f DEVICE,TYPE,STATE device status 2>/dev/null \
      | awk -F: '$2 == "ethernet" && $3 == "connected" { print $1; exit }')
    if [ -n "$eth" ]; then
      eth_ip=$("$ip" -4 -br addr show "$eth" 2>/dev/null | awk '{ print $3 }' | cut -d/ -f1)
      add_seg "󰛳"
      class="ethernet"
      add_tip "󰛳  Ethernet''${eth_ip:+  ·  $eth_ip}"
    fi

    # ── Wi-Fi ───────────────────────────────────────────────────
    wifi=$("$nmcli" -t -f ACTIVE,SSID,SIGNAL device wifi 2>/dev/null | grep -m1 '^yes:')
    if [ -n "$wifi" ]; then
      ssid=$(printf '%s' "$wifi" | cut -d: -f2)
      signal=$(printf '%s' "$wifi" | cut -d: -f3)
      if   [ "''${signal:-0}" -ge 80 ]; then icon="󰤨"
      elif [ "''${signal:-0}" -ge 60 ]; then icon="󰤥"
      elif [ "''${signal:-0}" -ge 40 ]; then icon="󰤢"
      elif [ "''${signal:-0}" -ge 20 ]; then icon="󰤟"
      else                                    icon="󰤯"
      fi
      add_seg "$icon"
      [ "$class" = "disconnected" ] && class="wifi"
      add_tip "$icon  ''${ssid:-Wi-Fi}''${signal:+  ·  $signal%}"
    fi

    # ── VPN (nmcli, fallback interfaces) ────────────────────────
    vpn=$("$nmcli" -t -f TYPE,NAME connection show --active 2>/dev/null \
      | awk -F: '$1 == "vpn" || $1 == "wireguard" { print $2; exit }')
    if [ -z "$vpn" ]; then
      vpn=$("$ip" -br link show 2>/dev/null \
        | awk '($2 == "UP" || $2 == "UNKNOWN") && $1 ~ /^(tun|wg|proton|ppp)/ { sub(/@.*/, "", $1); print $1; exit }')
    fi
    if [ -n "$vpn" ]; then
      add_seg "󰦝"
      add_tip "󰦝  VPN  ·  $vpn"
    fi

    if [ -z "$text" ]; then
      text="󰤭"
      tip="Disconnected"
    fi

    "$jq" -cn --arg text "$text" --arg class "$class" --arg tooltip "$tip" \
      '{ text: $text, class: $class, tooltip: $tooltip }'
  '';

  vol-up = pkgs.writeShellScriptBin "vol-up" ''
    ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%+ --limit 1.0
    ${volGetText}
    ${updateOsd}
  '';

  vol-down = pkgs.writeShellScriptBin "vol-down" ''
    ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SINK@ 5%-
    ${volGetText}
    ${updateOsd}
  '';

  vol-mute = pkgs.writeShellScriptBin "vol-mute" ''
    ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SINK@ toggle
    ${volGetText}
    ${updateOsd}
  '';

  mic-mute = pkgs.writeShellScriptBin "mic-mute" ''
    wpctl=${pkgs.wireplumber}/bin/wpctl
    ${micSource}
    [ -z "$src" ] && exit 0

    "$wpctl" set-mute "$src" toggle
    if "$wpctl" get-volume "$src" | grep -q MUTED; then
      OSD_TEXT="󰍭  Muted"
    else
      OSD_TEXT="󰍬  Live"
    fi
    ${updateOsd}
  '';

  mic-status = pkgs.writeShellScriptBin "mic-status" ''
    ${micSource}
    if [ -n "$src" ] && ${pkgs.wireplumber}/bin/wpctl get-volume "$src" | grep -q MUTED; then
      echo true
    else
      echo false
    fi
  '';

  bright-up = pkgs.writeShellScriptBin "bright-up" ''
    ${pkgs.brightnessctl}/bin/brightnessctl set 5%+
    ${brightGetText}
    ${updateOsd}
  '';

  bright-down = pkgs.writeShellScriptBin "bright-down" ''
    ${pkgs.brightnessctl}/bin/brightnessctl set 5%-
    ${brightGetText}
    ${updateOsd}
  '';

  wifi-toggle = pkgs.writeShellScriptBin "wifi-toggle" ''
    if ${pkgs.networkmanager}/bin/nmcli radio wifi | grep -q enabled; then
      ${pkgs.networkmanager}/bin/nmcli radio wifi off
    else
      ${pkgs.networkmanager}/bin/nmcli radio wifi on
    fi
    ${updateOsd}
  '';

  bluetooth-toggle = pkgs.writeShellScriptBin "bluetooth-toggle" ''
    if ${pkgs.bluez}/bin/bluetoothctl show | grep -q "Powered: yes"; then
      ${pkgs.bluez}/bin/bluetoothctl power off
    else
      ${pkgs.bluez}/bin/bluetoothctl power on
    fi
    ${updateOsd}
  '';

  waybar-toggle = pkgs.writeShellScriptBin "waybar-toggle" ''
    if pidof waybar > /dev/null; then
      pkill waybar
    else
      hyprctl dispatch exec waybar
    fi
  '';

  nightshift-toggle = pkgs.writeShellScriptBin "nightshift-toggle" ''
    if ${pkgs.procps}/bin/pidof "hyprsunset" > /dev/null; then
      pkill hyprsunset
      OSD_TEXT="󰖔  Night Shift Off"
    else
      ${pkgs.hyprsunset}/bin/hyprsunset -t 4500 &
      OSD_TEXT="󰖔  Night Shift On"
    fi
    ${updateOsd}
  '';

  focus-toggle = pkgs.writeShellScriptBin "focus-toggle" ''
    if test -f "$XDG_RUNTIME_DIR/hypr-focus-mode"; then
      rm "$XDG_RUNTIME_DIR/hypr-focus-mode"
      OSD_TEXT="󰈈  Focus Off"
      ${updateOsd}
      ${pkgs.hyprland}/bin/hyprctl reload
      ${pkgs.hyprland}/bin/hyprctl dispatch exec waybar
    else
      touch "$XDG_RUNTIME_DIR/hypr-focus-mode"
      OSD_TEXT="󰈈  Focus On"
      ${updateOsd}
      ${pkgs.procps}/bin/pkill waybar || true
      ${pkgs.hyprland}/bin/hyprctl keyword animations:enabled false
      ${pkgs.hyprland}/bin/hyprctl keyword general:gaps_in 0
      ${pkgs.hyprland}/bin/hyprctl keyword general:gaps_out 0
      ${pkgs.hyprland}/bin/hyprctl keyword decoration:active_opacity 1
      ${pkgs.hyprland}/bin/hyprctl keyword decoration:inactive_opacity 1
      ${pkgs.hyprland}/bin/hyprctl keyword decoration:rounding 0
    fi
  '';

  dnd-toggle = pkgs.writeShellScriptBin "dnd-toggle" ''
    state=$(${pkgs.swaynotificationcenter}/bin/swaync-client -d)
    if [ "$state" = "true" ]; then
      OSD_TEXT="󰂛  Do Not Disturb On"
    else
      OSD_TEXT="󰂚  Do Not Disturb Off"
    fi
    ${updateOsd}
  '';

  output-cycle = pkgs.writeShellScriptBin "output-cycle" ''
    wpctl=${pkgs.wireplumber}/bin/wpctl
    jq=${pkgs.jq}/bin/jq
    pwdump=${pkgs.pipewire}/bin/pw-dump

    # Sink IDs in pw-dump order.
    ids=($("$pwdump" | "$jq" -r '.[] | select(.info.props."media.class"=="Audio/Sink") | .id'))
    n=''${#ids[@]}
    [ "$n" -eq 0 ] && exit 0

    cur=$("$wpctl" inspect @DEFAULT_AUDIO_SINK@ 2>/dev/null | sed -n 's/^id \([0-9]*\),.*/\1/p')

    next_index=0
    for i in "''${!ids[@]}"; do
      if [ "''${ids[$i]}" = "$cur" ]; then
        next_index=$(( (i + 1) % n ))
        break
      fi
    done
    next=''${ids[$next_index]}

    "$wpctl" set-default "$next"
    desc=$("$pwdump" | "$jq" -r --argjson id "$next" '.[] | select(.id==$id) | .info.props."node.description"')
    OSD_TEXT="󰓃  ''${desc:-Output}"
    ${updateOsd}
  '';

  input-cycle = pkgs.writeShellScriptBin "input-cycle" ''
    wpctl=${pkgs.wireplumber}/bin/wpctl
    jq=${pkgs.jq}/bin/jq
    pwdump=${pkgs.pipewire}/bin/pw-dump

    # Source IDs in pw-dump order.
    ids=($("$pwdump" | "$jq" -r '.[] | select(.info.props."media.class"=="Audio/Source") | .id'))
    n=''${#ids[@]}
    [ "$n" -eq 0 ] && exit 0

    cur=$("$wpctl" inspect @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | sed -n 's/^id \([0-9]*\),.*/\1/p')

    next_index=0
    for i in "''${!ids[@]}"; do
      if [ "''${ids[$i]}" = "$cur" ]; then
        next_index=$(( (i + 1) % n ))
        break
      fi
    done
    next=''${ids[$next_index]}

    "$wpctl" set-default "$next"
    desc=$("$pwdump" | "$jq" -r --argjson id "$next" '.[] | select(.id==$id) | .info.props."node.description"')
    OSD_TEXT="󰍬  ''${desc:-Input}"
    ${updateOsd}
  '';

  color-pick = pkgs.writeShellScriptBin "color-pick" ''
    # hyprpicker -a already copies the color to the clipboard.
    color=$(${pkgs.hyprpicker}/bin/hyprpicker -a 2>/dev/null)
    if [ -n "$color" ]; then
      OSD_TEXT="󰈊  $color"
    else
      OSD_TEXT="󰈊  Cancelled"
    fi
    ${updateOsd}
  '';

  screenshot-edit = pkgs.writeShellScriptBin "screenshot-edit" ''
    ${pkgs.hyprshot}/bin/hyprshot -m region --raw 2>/dev/null \
      | ${pkgs.satty}/bin/satty --filename -
  '';

  record-toggle = pkgs.writeShellScriptBin "record-toggle" ''
    if pgrep -x wf-recorder >/dev/null; then
      # -INT lets wf-recorder finalize the file cleanly.
      pkill -INT -x wf-recorder
      OSD_TEXT="󰕧  Recording saved"
    else
      dir="$HOME/Videos"
      mkdir -p "$dir"
      file="$dir/rec-$(date +%Y%m%d-%H%M%S).mp4"
      ${pkgs.wf-recorder}/bin/wf-recorder -f "$file" >/dev/null 2>&1 &
      OSD_TEXT="󰑊  Recording…"
    fi
    ${updateOsd}
  '';

  power-cycle = pkgs.writeShellScriptBin "power-cycle" ''
    ppd=${pkgs.power-profiles-daemon}/bin/powerprofilesctl
    cur=$("$ppd" get)
    case "$cur" in
      power-saver) next=balanced;    icon="󰾅" ;;
      balanced)    next=performance; icon="󰓅" ;;
      performance) next=power-saver; icon="󰌪" ;;
      *)           next=balanced;    icon="󰾅" ;;
    esac
    "$ppd" set "$next"
    OSD_TEXT="$icon  ''${next^}"
    ${updateOsd}
  '';

  airplane-toggle = pkgs.writeShellScriptBin "airplane-toggle" ''
    # Reuse nmcli + bluetoothctl (unprivileged) instead of rfkill.
    on=false
    nmcli radio wifi 2>/dev/null | grep -q enabled && on=true
    bluetoothctl show 2>/dev/null | grep -q "Powered: yes" && on=true
    if $on; then
      nmcli radio wifi off 2>/dev/null
      bluetoothctl power off >/dev/null 2>&1 || true
      OSD_TEXT="󰀝  Airplane On"
    else
      nmcli radio wifi on 2>/dev/null
      bluetoothctl power on >/dev/null 2>&1 || true
      OSD_TEXT="󰀞  Airplane Off"
    fi
    ${updateOsd}
  '';

  clipboard-menu = pkgs.writeShellScriptBin "clipboard-menu" ''
    list=$(${pkgs.cliphist}/bin/cliphist list)
    selected=$(printf '%s\n' "$list" | cut -f2- | ${tofiMenu} --prompt-text "Clipboard: ")
    [ -n "$selected" ] && printf '%s\n' "$list" \
      | awk -F'\t' -v s="$selected" '$2 == s {print; exit}' \
      | ${pkgs.cliphist}/bin/cliphist decode \
      | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  emoji-picker = pkgs.writeShellScriptBin "emoji-picker" ''
    export PATH="${pkgs.wtype}/bin:${pkgs.wl-clipboard}/bin:$PATH"
    export BEMOJI_PICKER_CMD="${tofiMenu} --prompt-text 'emoji: '"
    # -t types the emoji (wtype), -c also copies it.
    exec ${pkgs.bemoji}/bin/bemoji -t -c
  '';

  icon-picker = pkgs.writeShellScriptBin "icon-picker" ''
    selected=$(${tofiMenu} --font "${config.stylix.fonts.monospace.name}" --prompt-text 'icon: ' < ${nerdFontIconList})
    [ -z "$selected" ] || icon=$(printf '%s\n' "$selected" | awk '{print $1}')
    [ -n "''${icon:-}" ] || exit 0
    ${pkgs.wtype}/bin/wtype "$icon"
    printf '%s' "$icon" | ${pkgs.wl-clipboard}/bin/wl-copy
  '';

  caffeine-toggle = pkgs.writeShellScriptBin "caffeine-toggle" ''
    # Pause hypridle (stay awake) or resume it.
    if systemctl --user is-active --quiet hypridle; then
      systemctl --user stop hypridle
      OSD_TEXT="󰅶  Keep Awake On"
    else
      systemctl --user start hypridle
      OSD_TEXT="󰾫  Keep Awake Off"
    fi
    ${updateOsd}
  '';
}
