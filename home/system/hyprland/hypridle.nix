{ config, pkgs, ... }: {
  home.packages = with pkgs; [ hypridle ];

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        ignore_dbus_inhibit = false
    }

    # Screenlock
    listener {
        timeout = 600
        on-timeout = ${pkgs.hyprlock}/bin/hyprlock
        on-resume = ${pkgs.libnotify}/bin/notify-send "Welcome back ${config.home.username}!"
    }

    # Suspend (not working on my laptop)
    #listener {
    #    timeout = 660
    #    on-timeout = systemctl suspend
    #    on-resume = ${pkgs.libnotify}/bin/notify-send "Welcome back to your desktop!"
    #}
  '';
}
