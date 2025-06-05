# Kitty is a fast, featureful, GPU based terminal emulator
{
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+j" = "neighboring_window down";
      "ctrl+shift+h" = "neighboring_window left";
      "ctrl+shift+l" = "neighboring_window right";
      "ctrl+shift+k" = "neighboring_window up";
    };
    settings = {
      scrollback_lines = 10000;
      initial_window_width = 1200;
      initial_window_height = 600;
      update_check_interval = 0;
      enable_audio_bell = false;
      confirm_os_window_close = "0";
      remember_window_size = "no";
      disable_ligatures = "never";
      url_style = "curly";
      copy_on_select = "clipboard";
      cursor_shape = "Underline";
      cursor_underline_thickness = 3;
      cursor_trail = 3;
      cursor_trail_decay = "0.1 0.4";
      window_padding_width = 10;
      open_url_with = "default";
    };
  };
}
