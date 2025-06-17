# Kitty is a fast, featureful, GPU based terminal emulator
{
  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+shift+tab" = "new_tab";
      "ctrl+j" = ''kitten pass_keys.py bottom ctrl+j'';
      "ctrl+k" = ''kitten pass_keys.py top    ctrl+k'';
      "ctrl+h" = ''kitten pass_keys.py left   ctrl+h'';
      "ctrl+l" = ''kitten pass_keys.py right  ctrl+l'';
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
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/mykitty";
    };
  };

  xdg.configFile = {
    "kitty/pass_keys.py".text = ''
      import re

      from kittens.tui.handler import result_handler
      from kitty.key_encoding import KeyEvent, parse_shortcut


      def is_window_vim(window, vim_id):
          fp = window.child.foreground_processes
          return any(re.search(vim_id, p['cmdline'][0] if len(p['cmdline']) else "", re.I) for p in fp)


      def encode_key_mapping(window, key_mapping):
          mods, key = parse_shortcut(key_mapping)
          event = KeyEvent(
              mods=mods,
              key=key,
              shift=bool(mods & 1),
              alt=bool(mods & 2),
              ctrl=bool(mods & 4),
              super=bool(mods & 8),
              hyper=bool(mods & 16),
              meta=bool(mods & 32),
          ).as_window_system_event()

          return window.encoded_key(event)


      def main():
          pass


      @result_handler(no_ui=True)
      def handle_result(args, result, target_window_id, boss):
          direction = args[1]
          key_mapping = args[2]
          vim_id = args[3] if len(args) > 3 else "n?vim"

          window = boss.window_id_map.get(target_window_id)

          if window is None:
              return
          if is_window_vim(window, vim_id):
              for keymap in key_mapping.split(">"):
                  encoded = encode_key_mapping(window, keymap)
                  window.write_to_child(encoded)
          else:
              boss.active_tab.neighboring_window(direction)
    '';
    "kitty/neighboring_window.py".text = ''
      def main():
          pass


      def handle_result(args, result, target_window_id, boss):
          return boss.active_tab.current_layout.name


      handle_result.no_ui = True
    '';
  };
}
