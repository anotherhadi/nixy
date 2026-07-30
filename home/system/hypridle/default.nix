# hypridle handles idle management: lock the screen, turn the display off, and
# suspend after periods of inactivity. The `caffeine-toggle` script pauses it.
{...}: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Avoid starting multiple hyprlock instances.
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300; # 5 min → lock
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 360; # 6 min → screen off
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30 min → suspend
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
