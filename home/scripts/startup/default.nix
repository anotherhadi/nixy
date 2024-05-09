# File runned at startup by Hyprland
{ pkgs, ... }:
let
  variable = import ../../../variables.nix;

  nextcloud-watch = pkgs.writeShellScriptBin "nextcloud-watch" ''
    # Start nextcloud if I'm on my networks
    while true;do
      ssid=$(nmcli -t -f name connection show --active | head -n1)
      status=$(pgrep -n nextcloud)
      if [[ -z $status ]]; then
        service_status="inactive"
      else
        service_status="active"
      fi

      if [[ $ssid == "inthecloud" || $ssid == "Wired connection 2" ]]; then
        if [[ $service_status == "inactive" ]]; then
            ${pkgs.nextcloud-client}/bin/nextcloud --background
        fi
      else
        if [[ $service_status == "active" ]]; then
            pkill nextcloud
        fi
      fi
      sleep 120
    done
  '';

  startup = pkgs.writeShellScriptBin "startup" ''
    # Because HM enabling services suck.

    [[ ${
      toString variable.enableSops
    } == "true" ]] && systemctl --user start sops-nix

    [[ ${toString variable.enableNextcloud} == "true" ]] && nextcloud-watch &

    echo "${toString variable.enableNextcloud}" > /tmp/nextcloud-enable
    system-notif &
    ${pkgs.waybar}/bin/waybar &
  '';

in { home.packages = with pkgs; [ startup nextcloud-watch nextcloud-client ]; }
