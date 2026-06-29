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
  ];

  wayland.windowManager.hyprland.settings.exec-once = [
    "waybar"
  ];
}
