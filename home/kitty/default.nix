{
  programs.kitty = {
    enable = true;
    settings = {

      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      font_family = "FiraCode Nerd Font";
      font_size = 13;
      cursor_shape = "Underline";
      cursor_underline_thickness = 1;
      window_padding_width = 10;
      url_style = "curly";
      confirm_os_window_close = "0";
      remember_window_size = "no";
      disable_ligatures = "never";
      shell = "zsh";
      initial_window_width = 1000;
      initial_window_height = 600;

      # Special
      background = "#090914";
      url_color = "#9978F8";

      # Black
      color0 = "#414868";
      color8 = "#515878";

      # Red
      color1 = "#f7768e";
      color9 = "#f7869e";

      # Green
      color2 = "#73daca";
      color10 = "#83eada";

      # Yellow
      color3 = "#e0af68";
      color11 = "#f0bf78";

      # Blue
      color4 = "#7aa2f7";
      color12 = "#8ab2f7";

      # Magenta
      color5 = "#9978F8";
      color13 = "#A988F8";

      # Cyan
      color6 = "#7dcfff";
      color14 = "#8ddfff";

      # White
      color7 = "#E4E5E7";
      color15 = "#f4f5f7";

      # Cursor
      cursor = "#FBFBFB";
      cursor_text_color = "#090914";

      # Selection highlight
      selection_foreground = "#9978F8";
      selection_background = "#28344a";
    };
  };
}
