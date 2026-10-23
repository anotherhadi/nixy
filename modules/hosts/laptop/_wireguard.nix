{
  config,
  pkgs,
  ...
}: let
  vpnConnection = "wg-vpn";

  toggleVpn = pkgs.writeShellScript "toggle-wg-vpn" ''
    set -euo pipefail
    nmcli="${pkgs.networkmanager}/bin/nmcli"

    if "$nmcli" -t -f NAME connection show --active | grep -qx "${vpnConnection}"; then
      "$nmcli" connection down "${vpnConnection}"
      OSD_TEXT="󰦝  VPN Off"
    else
      "$nmcli" connection up "${vpnConnection}"
      OSD_TEXT="󰦝  VPN On"
    fi

    # Same as the osd script (modules/desktop/scripts/osd.nix)
    osd="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/osd"
    mkdir -p "$osd"
    printf '%s' "$OSD_TEXT" > "$osd/vpn"
    ${pkgs.procps}/bin/pkill -x -RTMIN+8 swaybar-status 2>/dev/null || true
  '';
in {
  environment.systemPackages = [
    (pkgs.makeDesktopItem {
      name = "toggle-wg-vpn";
      desktopName = "Toggle VPN";
      comment = "Turn the WireGuard VPN connection on or off";
      icon = "network-vpn-symbolic";
      exec = "${toggleVpn}";
      terminal = false;
      categories = ["Network"];
    })
  ];

  sops = {
    secrets.wireguard-private-key = {};
    templates."wg-vpn.nmconnection" = {
      path = "/etc/NetworkManager/system-connections/wg-vpn.nmconnection";
      mode = "0600";
      owner = "root";
      group = "root";
      content = ''
        [connection]
        id=wg-vpn
        type=wireguard
        interface-name=wg-vpn
        autoconnect=true
        autoconnect-priority=0

        [wireguard]
        private-key=${config.sops.placeholder.wireguard-private-key}

        [wireguard-peer.36G8+pInNcPK9F1TpHglWs9Pk5uJOY9o8SCNrCBgvHE=]
        endpoint=89.222.96.158:51820
        allowed-ips=0.0.0.0/0;
        persistent-keepalive=25

        [ipv4]
        method=manual
        address1=10.2.0.2/32
        dns=10.2.0.1;

        [ipv6]
        method=manual
        route1=::/0,,1
        route1_options=type=blackhole
      '';
    };
  };
}
