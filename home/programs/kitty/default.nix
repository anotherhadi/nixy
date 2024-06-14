{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;
      initial_window_width = 1200;
      initial_window_height = 600;
      update_check_interval = 0;
      enable_audio_bell = false;
      confirm_os_window_close = "0";
      remember_window_size = "no";
      disable_ligatures = "never";
      shell = "${pkgs.tmux}/bin/tmux";
      url_style = "curly";
      cursor_shape = "Underline";
      cursor_underline_thickness = 1;
      window_padding_width = config.var.theme.gaps-out;

      # Font
      font_family = config.var.theme.font-mono;
      font_size = 13;

      # Colors
      background = "#" + config.var.theme.colors.bg;
      url_color = "#" + config.var.theme.colors.accent;
      color0 = "#" + config.var.theme.colors.c0;
      color8 = "#" + config.var.theme.colors.c8;
      color1 = "#" + config.var.theme.colors.c1;
      color9 = "#" + config.var.theme.colors.c9;
      color2 = "#" + config.var.theme.colors.c2;
      color10 = "#" + config.var.theme.colors.c10;
      color3 = "#" + config.var.theme.colors.c3;
      color11 = "#" + config.var.theme.colors.c11;
      color4 = "#" + config.var.theme.colors.c4;
      color12 = "#" + config.var.theme.colors.c12;
      color5 = "#" + config.var.theme.colors.c5;
      color13 = "#" + config.var.theme.colors.c13;
      color6 = "#" + config.var.theme.colors.c6;
      color14 = "#" + config.var.theme.colors.c14;
      color7 = "#" + config.var.theme.colors.c7;
      color15 = "#" + config.var.theme.colors.c15;
      cursor = "#" + config.var.theme.colors.fg;
      cursor_text_color = "#" + config.var.theme.colors.bg;
      selection_foreground = "#" + config.var.theme.colors.accentFg;
      selection_background = "#" + config.var.theme.colors.accent;
    };
  };
}
