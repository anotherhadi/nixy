# hypridle handles idle management: lock the screen, turn the display off, and
# suspend after periods of inactivity. The `caffeine-toggle` script pauses it.
{
  pkgs,
  scripts,
  ...
}: {
  scripts.caffeine-toggle = pkgs.writeShellScriptBin "caffeine-toggle" ''
    # Pause hypridle (stay awake) or resume it.
    if systemctl --user is-active --quiet hypridle; then
      systemctl --user stop hypridle
      OSD_TEXT="󰅶  Keep Awake On"
    else
      systemctl --user start hypridle
      OSD_TEXT="󰾫  Keep Awake Off"
    fi
    ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
  '';

  home.packages = [scripts.caffeine-toggle];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # Avoid starting multiple hyprlock instances.
        lock_cmd = "${pkgs.procps}/bin/pidof ${pkgs.hyprlock}/bin/hyprlock || ${pkgs.hyprlock}/bin/hyprlock --grace 5";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300; # 5 min → lock
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 720; # 12 min → screen off
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30 min → suspend
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  xdg.desktopEntries = {
    caffeine-toggle = {
      name = "Keep Awake";
      exec = "${scripts.caffeine-toggle}/bin/caffeine-toggle";
      icon = "my-caffeine-on-symbolic";
      comment = "Pause or resume idle locking and suspend";
      categories = ["System"];
      terminal = false;
      settings.Keywords = "caffeine;idle;awake;inhibit;suspend;";
    };
  };
}
