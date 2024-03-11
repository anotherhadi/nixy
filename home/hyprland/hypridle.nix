{ pkgs, ... }: {
  home.packages = with pkgs; [ hypridle ];

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        ignore_dbus_inhibit = false             # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
    }

    # Screenlock
    listener {
        timeout = 600                            # in seconds
        on-timeout = hyprlock # command to run when timeout has passed
        on-resume = notify-send "Welcome back hadi!"  # command to run when activity is detected after timeout has fired.
    }

    # Suspend
    listener {
        timeout = 660                            # in seconds
        on-timeout = systemctl suspend # command to run when timeout has passed
        # on-resume = notify-send "Welcome back to your desktop!"  # command to run when activity is detected after timeout has fired.
    }
  '';
}
