# Kitty is a fast, featureful, GPU based terminal emulator
{
  programs.kitty = {
    enable = true;
    keybindings = {
      # Reset existing mappings
      "ctrl+alt+tab" = "next_tab";
      "ctrl+alt+shift+tab" = "previous_tab";
      # Send Ctrl Tab and Ctrl + Shift + Tab for Tmux navigation
      "ctrl+tab" = "send_text all \\x1b[27;5;9~";
      "ctrl+shift+tab" = "send_text all \\x1b[27;6;9~";
      "alt+tab" = "send_text all \\x1b[27;3;9~";
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
