{ config, ... }: {

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        no_fade_in = true;
        no_fade_out = true;
      };

      background = {
        monitor = "";
        path = "$HOME/wallpapers/${config.var.theme.wallpaper}";
        color = "rgb(${config.var.theme.colors.bg})";

        blur_size = 4;
        blur_passes = 3;
        noise = 1.17e-2;
        contrast = 1.3;
        brightness = 0.8;
        vibrancy = 0.21;
        vibrancy_darkness = 0.0;
      };

      input-field = [{
        monitor = "";
        size = "250, 50";
        outline_thickness = 3;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.64; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        outer_color = "rgb(${config.var.theme.colors.accent})";
        inner_color = "rgb(${config.var.theme.colors.bg})";
        font_color = "rgb(${config.var.theme.colors.fg})";
        fade_on_empty = true;
        placeholder_text =
          "Password..."; # Text rendered in the input box when it's empty.
        position = "0, 80";
        halign = "center";
        valign = "bottom";
      }];

      label = [
        # Current time
        {
          monitor = "";
          text =
            ''cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"'';
          color = "rgb(${config.var.theme.colors.fg})";
          font_size = 64;
          font_family = config.var.theme.font;
          position = "0, 16";
          halign = "center";
          valign = "center";
        }
        # User label
        {
          monitor = "";
          text = ''
            Hey <span text_transform="capitalize" size="larger">$USER</span>'';
          color = "rgb(${config.var.theme.colors.fg})";
          font_size = 20;
          font_family = config.var.theme.font;
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
        # Type to unlock
        {
          monitor = "";
          text = "Type to unlock!";
          color = "rgb(${config.var.theme.colors.fg})";
          font_size = 16;
          font_family = config.var.theme.font;
          position = "0, 30";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
