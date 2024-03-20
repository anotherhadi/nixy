# File runned at startup by Hyprland
{ pkgs, config, ... }:
let
  homedir = config.home.homeDirectory;

  battery-notif = pkgs.writeShellScriptBin "battery-notif" ''
    # Send notifications when low on battery and not in charge
    while true; do
      battery_level=$(cat /sys/class/power_supply/BAT*/capacity)
      battery_status=$(cat /sys/class/power_supply/BAT*/status)
      if [[ $battery_level -le 20 ]] && [[ $battery_status == "Discharging" ]]; then
        ${pkgs.libnotify}/bin/notify-send "󰁻  Low battery" "Battery level is $battery_level%"
      elif [[ $battery_level -le 10 ]] && [[ $battery_status == "Discharging" ]]; then
        ${pkgs.libnotify}/bin/notify-send --urgency=critical "󰁺  Very low battery" "Battery level is $battery_level%"
      fi
      sleep 60
    done
  '';

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

    systemctl --user start sops-nix

    nextcloud-watch &
    battery-notif &
  '';

in {
  home.packages = with pkgs; [
    startup
    battery-notif
    nextcloud-watch
    nextcloud-client
  ];
}
