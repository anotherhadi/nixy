# Hyprlock is a lockscreen for Hyprland
{ config, lib, ... }:
let
  foreground = "rgba(${config.theme.textColorOnWallpaper}ee)";
  font = config.stylix.fonts.serif.name;
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        ignore_empty_input = true;
        hide_cursor = true;
      };

      background = { brightness = 0.7172; };

      label = [
        {
          # Day-Month-Date
          monitor = "";
          text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
          color = foreground;
          font_size = 28;
          font_family = font + " Bold";
          position = "0, 490";
          halign = "center";
          valign = "center";
        }
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "<span>$(date +"%I:%M")</span>"'';
          color = foreground;
          font_size = 160;
          font_family = "steelfish outline regular";
          position = "0, 370";
          halign = "center";
          valign = "center";
        }
        # USER
        {
          monitor = "";
          text = "    $USER";
          color = foreground;
          font_size = 18;
          font_family = font + " Bold";
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];

      # INPUT FIELD
      input-field = lib.mkForce {
        size = "300, 60";
        outline_thickness = 2;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgba(25, 25, 25, 0)";
        inner_color = "rgba(25, 25, 25, 0.1)";
        font_color = foreground;
        fade_on_empty = false;
        font_family = font + " Bold";
        placeholder_text = "<i>🔒 Enter Password</i>";
        position = "0, -250";
        halign = "center";
        valign = "center";
      };
    };
  };
}
