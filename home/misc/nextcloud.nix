{ pkgs, ... }: {
  systemd.user.services.watch-nextcloud = {
    Unit = { Description = "Start Nextcloud if I'm on one of my network"; };
    Install = { WantedBy = [ "default.target" ]; };
    Service = {
      ExecStart = "${pkgs.writeShellScript "watch-nextcloud" ''
        while 1;do
          ssid=$(nmcli -t -f name connection show --active | head -n1)
          if [[ $ssid == "inthecloud" || $ssid == "Wired connection 2" ]]; then
            status=$(systemctl --user status nextcloud-client)
            service_status=$(echo "$status" | awk '/Active:/ {print $2}')
            if [[ $service_status == "inactive" ]]; then
              systemctl --user start nextcloud-client
            fi
          else
            status=$(systemctl --user status nextcloud-client)
            service_status=$(echo "$status" | awk '/Active:/ {print $2}')
            if [[ $service_status == "active" ]]; then
              systemctl --user stop nextcloud-client
            fi
          fi
          sleep 120
        done
      ''}";
    };
  };
}
