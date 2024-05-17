# File runned at startup by Hyprland
{ pkgs, ... }:
let
  variable = import ../../../variables.nix;

  nextcloud-watch = pkgs.writeShellScriptBin "nextcloud-watch" ''
    # Start nextcloud if I'm on my local network
    while true;do
      sleep 120
      ssid=$(nmcli -t -f name connection show --active | head -n1)
      nextcloud_status=$(ps -aux | grep -E "/bin/nextcloud --background$")
      if [[ $nextcloud_status == "" ]]; then
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
            nextcloud_pid=$(pgrep -n nextcloud)
            kill $nextcloud_pid
        fi
      fi
    done
  '';

  startup = pkgs.writeShellScriptBin "startup" ''
    # Because HM enabling services suck.

    [[ ${
      toString variable.enableSops
    } == "1" ]] && systemctl --user start sops-nix

    [[ ${toString variable.enableNextcloud} == "1" ]] && nextcloud-watch &

    notify-system &
    ${pkgs.waybar}/bin/waybar &
  '';

in { home.packages = with pkgs; [ startup nextcloud-watch nextcloud-client ]; }
