{pkgs, ...}: let
  networkScript = pkgs.writeShellScript "waybar-network" ''
    for iface in $(${pkgs.iproute2}/bin/ip -br link show | awk '$2 == "UP" {print $1}' | grep -vE '^(lo|tun|proton|wg[0-9]|ppp|vpn|docker|br-|veth|virbr)'); do
      ip=$(${pkgs.iproute2}/bin/ip addr show "$iface" 2>/dev/null | grep 'inet ' | awk '{print $2}' | cut -d/ -f1 | head -1)
      if [ -n "$ip" ]; then
        if [[ "$iface" == wl* ]]; then
          ssid=$(${pkgs.iw}/bin/iw dev "$iface" link 2>/dev/null | grep SSID | sed 's/.*SSID: //')
          signal=$(${pkgs.iw}/bin/iw dev "$iface" link 2>/dev/null | grep signal | awk '{print $2}')
          printf '{"text": "󰤨", "class": "wifi", "tooltip": "  %s\\n  %s dBm"}\n' "$ssid" "$signal"
        else
          printf '{"text": "󰛳", "class": "ethernet", "tooltip": "  %s\\n  %s"}\n' "$iface" "$ip"
        fi
        exit 0
      fi
    done
    printf '{"text": "󰤭", "class": "disconnected", "tooltip": "Disconnected"}\n'
  '';

  updateOsd = ''
    [ -f /tmp/waybar-osd-pid ] && kill "$(cat /tmp/waybar-osd-pid)" 2>/dev/null
    printf '%s' "$OSD_TEXT" > /tmp/waybar-osd
    pkill -RTMIN+8 waybar 2>/dev/null
    ( sleep 2.5; rm -f /tmp/waybar-osd /tmp/waybar-osd-pid; pkill -RTMIN+8 waybar 2>/dev/null ) &
    printf '%s' "$!" > /tmp/waybar-osd-pid
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
    ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_SOURCE@ toggle
    if ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_SOURCE@ | grep -q MUTED; then
      OSD_TEXT="󰍭  Muted"
    else
      OSD_TEXT="󰍬  Live"
    fi
    ${updateOsd}
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
in {
  imports = [
    ./settings.nix
    ./style.nix
  ];

  _module.args.networkScript = networkScript;

  programs.waybar.enable = true;
  stylix.targets.waybar.enable = false;

  home.packages = with pkgs; [
    playerctl
    pavucontrol
    blueman
    iw
  ] ++ [vol-up vol-down vol-mute mic-mute bright-up bright-down];

  wayland.windowManager.hyprland.settings.exec-once = [
    "waybar"
  ];
}
