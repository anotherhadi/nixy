# - ## OpenVPN
#-
#- OpenVPN allows you to connect/disconnect quickly to a openVPN server
#-
#- - `openvpn-up` turn on the vpn
#- - `openvpn-down` turn down the vpn
#- - `openvpn-toggle` toggle the vpn
{ pkgs, ... }:
let
  id = "home"; # ID of the connection
  password-file = "/home/hadi/.config/vpn-password";

  openvpn-up = pkgs.writeShellScriptBin "openvpn-up"
    # bash 
    ''
      nmcli con up id ${id} passwd-file ${password-file}
      notif "VPN" "VPN activated" "The OpenVPN connection to ${id} has been activated"
    '';

  openvpn-down = pkgs.writeShellScriptBin "openvpn-down"
    # bash 
    ''
      nmcli con down id ${id}
      notif "VPN" "VPN deactivated" "The OpenVPN connection to ${id} has been deactivated"
    '';

  openvpn-toggle = pkgs.writeShellScriptBin "openvpn-toggle"
    # bash 
    ''
      if nmcli connection show --active | grep -q "${id}"; then
        openvpn-down
      else
        openvpn-up
      fi
    '';

in { home.packages = [ openvpn-up openvpn-down openvpn-toggle ]; }
