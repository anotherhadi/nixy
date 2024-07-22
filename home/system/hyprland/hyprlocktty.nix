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
        color = "rgb(${config.var.theme.colors.bg})";
      };

      input-field = [{
        monitor = "";
        size = "250, 50";
        outline_thickness = 3;
        dots_size = 0.2;
        dots_spacing = 0.64;
        dots_center = false;
        outer_color = "rgb(${config.var.theme.colors.bg})";
        inner_color = "rgb(${config.var.theme.colors.bg})";
        font_color = "rgb(${config.var.theme.colors.fg})";
        fade_on_empty = false;
        placeholder_text = "";
        position = "1190, -50";
        halign = "left";
        valign = "center";
      }];

      shape = [{
        monitor = "";
        size = "520, 200";
        color = "rgb(${config.var.theme.colors.bg})";
        rounding = "0";
        border_size = "3";
        border_color = "rgba(255, 255, 255, 1.0)";
        rotate = "0";
        xray = "false";
        position = "0, 0";
        halign = "center";
        valign = "center";
      }];

      label = [
        # Current time
        {
          monitor = "";
          text = ''cmd[update:900] echo "time: $(date +"%H:%M:%S")"'';
          color = "rgb(${config.var.theme.colors.fg})";
          font_size = config.var.theme.font-size;
          font_family = config.var.theme.font-mono;
          position = "1100, 50";
          halign = "left";
          valign = "center";
        }
        # Username
        {
          monitor = "";
          text = "username: ${config.var.username}";
          color = "rgb(${config.var.theme.colors.fg})";
          font_size = config.var.theme.font-size;
          font_family = config.var.theme.font-mono;
          position = "1100, 0";
          halign = "left";
          valign = "center";
        }
        # Password
        {
          monitor = "";
          text = "password: ";
          color = "rgb(${config.var.theme.colors.fg})";
          font_size = config.var.theme.font-size;
          font_family = config.var.theme.font-mono;
          position = "1100, -50";
          halign = "left";
          valign = "center";
        }
      ];
    };
  };
}
