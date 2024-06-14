{ pkgs, ... }: {

  services.hypridle = {
    enable = true;
    settings = {
      general = { ignore_dbus_inhibit = false; };
      listener = [
        {
          timeout = 600;
          on-timeout = pkgs.hyprlock + "/bin/hyprlock";
        }
        {
          timeout = 660;
          on-timeout = "systemctl suspend";
          on-resume = pkgs.libnotify
            + "/bin/notify-send 'Welcome back to your desktop!'";
        }
      ];
    };
  };
}
