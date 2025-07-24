{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.walker.homeManagerModules.default];

  wayland.windowManager.hyprland.settings = {
    bindd = [
      # "SUPER, R, Walker, exec, walker"
      # "SUPER, PERIOD, Emoji Picker, exec, walker -m emojis"
      # "SUPERSHIFT, PERIOD, Emoji Picker, exec, walker -m symbols"
      # "SUPER, M, Launch Minecraft Instance, exec, walker -m minecraft"
      # "SUPER, V, Open Clipboard, exec, walker -m clipboard"
      # "SUPERSHIFT, V, Clear Clipboard, exec, walker --clear-clipboard"
    ];
  };

  home.file."${config.xdg.configHome}/hypr/xdph.conf".text = ''
    screencopy {
        custom_picker_binary=${config.xdg.configHome}/hypr/walker_xdph_picker
    }
  '';

  home.file."${config.xdg.configHome}/hypr/walker_xdph_picker" = {
    text = ''walker -n --modules xdphpicker'';
    executable = true;
  };

  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      app_launch_prefix = "";
      as_window = false;
      close_when_open = false;
      disable_click_to_close = false;
      force_keyboard_focus = false;
      hotreload_theme = false;
      locale = "";
      monitor = "";
      terminal_title_flag = "";
      theme = "nixos";
      timeout = 0;
      activation_mode = {
        labels = "";
      };
      builtins = {
        applications = {
          context_aware = true;
          hide_actions_with_empty_query = true;
          history = true;
          icon = "applications-other";
          name = "applications";
          placeholder = "Applications";
          prioritize_new = true;
          refresh = true;
          show_generic = true;
          show_icon_when_single = true;
          show_sub_when_single = true;
          weight = 5;
          actions = {
            enabled = true;
            hide_category = false;
            hide_without_query = true;
          };
        };
        bookmarks = {
          hidden = true;
          icon = "bookmark";
          name = "bookmarks";
          placeholder = "Bookmarks";
          switcher_only = true;
          prefix = "b";
          weight = 5;
          entries = [
            {
              keywords = [
                "walker"
                "github"
              ];
              label = "Walker";
              url = "https://github.com/abenz1267/walker";
            }
          ];
        };
        calc = {
          hidden = false;
          icon = "accessories-calculator";
          min_chars = 4;
          name = "calc";
          placeholder = "Calculator";
          require_number = true;
          prefix = "=";
          weight = 5;
        };
        clipboard = {
          always_put_new_on_top = true;
          avoid_line_breaks = true;
          exec = "wl-copy";
          image_height = 300;
          max_entries = 10;
          name = "clipboard";
          placeholder = "Clipboard";
          switcher_only = true;
          prefix = ":";
          weight = 5;
        };
        commands = {
          icon = "utilities-terminal";
          name = "commands";
          placeholder = "Commands";
          switcher_only = true;
          weight = 5;
          prefix = "$";
        };
        dmenu = {
          hidden = true;
          name = "dmenu";
          placeholder = "Dmenu";
          show_icon_when_single = true;
          switcher_only = true;
          weight = 5;
        };
        emojis = {
          hidden = false;
          exec = "wl-copy";
          name = "emojis";
          placeholder = "Emojis";
          show_unqualified = false;
          prefix = "e";
          typeahead = true;
          weight = 5;
        };
        finder = {
          cmd_alt = "xdg-open $(dirname ~/%RESULT%)";
          concurrency = 8;
          fd_flags = "--ignore-vcs --type file --type directory";
          icon = "file";
          ignore_gitignore = true;
          name = "finder";
          placeholder = "Finder";
          preview_images = false;
          refresh = true;
          show_icon_when_single = true;
          prefix = "/";
          switcher_only = true;
          use_fd = true;
          weight = 5;
        };
        hyprland_keybinds = {
          prefix = "kbd";
          name = "hyprland_keybinds";
          path = "~/.config/hypr/hyprland.conf";
          placeholder = "Hyprland Keybinds";
          show_sub_when_single = true;
          switcher_only = true;
          weight = 5;
        };
        runner = {
          prefix = "$";
          eager_loading = true;
          generic_entry = false;
          history = true;
          icon = "utilities-terminal";
          name = "runner";
          placeholder = "Runner";
          refresh = true;
          typeahead = true;
          use_fd = true;
          weight = 5;
        };
        switcher = {
          name = "switcher";
          placeholder = "Switcher";
          icon = "search";
          prefix = "w";
          weight = 5;
        };
        symbols = {
          hidden = true;
          after_copy = "";
          history = true;
          name = "symbols";
          placeholder = "Symbols";
          switcher_only = true;
          typeahead = true;
          prefix = "s";
          weight = 5;
        };
        ssh = {
          hidden = true;
          history = true;
          icon = "preferences-system-network";
          name = "ssh";
          placeholder = "SSH";
          refresh = true;
          prefix = "ssh";
          switcher_only = true;
          weight = 5;
        };
        custom_commands = {
          hidden = true;
          icon = "utilities-terminal";
          name = "custom_commands";
          placeholder = "Custom Commands";
          weight = 5;
        };
        translation = {
          hidden = true;
          delay = 1000;
          icon = "accessories-dictionary";
          name = "translation";
          placeholder = "Translation";
          provider = "googlefree";
          switcher_only = true;
          prefix = "trad";
          weight = 5;
        };
        websearch = {
          icon = "applications-internet";
          keep_selection = true;
          name = "websearch";
          placeholder = "Websearch";
          prefix = "!";
          weight = 5;
          entries = [
            {
              name = "SearXNG";
              url = "https://search.orangc.net/search?q=%TERM%";
            }
            {
              name = "Google";
              url = "https://www.google.com/search?q=%TERM%";
              switcher_only = true;
            }
          ];
        };
        windows = {
          icon = "view-restore";
          name = "windows";
          prefix = "win";
          placeholder = "Windows";
          show_icon_when_single = true;
          weight = 5;
        };
        xdph_picker = {
          hidden = true;
          name = "xdphpicker";
          placeholder = "Screen/Window Picker";
          show_sub_when_single = true;
          switcher_only = true;
          weight = 5;
        };
      };
      keys = {
        accept_typeahead = ["tab"];
        close = ["esc"];
        next = ["down"];
        prev = ["up"];
        remove_from_history = ["shift backspace"];
        resume_query = ["ctrl r"];
        toggle_exact_search = ["ctrl m"];
        activation_modifiers = {
          keep_open = "shift";
        };
      };
      list = {
        dynamic_sub = true;
        keyboard_scroll_style = "emacs";
        max_entries = 50;
        placeholder = "No Results";
        show_initial_entries = true;
        single_click = true;
        visibility_threshold = 20;
      };
      search = {
        argument_delimiter = "#";
        delay = 0;
        placeholder = "Search...";
        resume_last_query = false;
      };
    };
    theme.layout = {
      ui = {
        anchors = {
          bottom = true;
          left = true;
          right = true;
          top = true;
        };
        window = {
          h_align = "fill";
          v_align = "fill";
          box = {
            h_align = "center";
            width = 450;
            bar = {
              orientation = "horizontal";
              position = "end";
              entry = {
                h_align = "fill";
                h_expand = true;
                icon = {
                  h_align = "center";
                  h_expand = true;
                  pixel_size = 24;
                  theme = "";
                };
              };
            };
            margins = {
              top = 200;
            };
            scroll = {
              list = {
                marker_color = "#1BFFE1";
                max_height = 300;
                max_width = 400;
                min_width = 400;
                width = 400;
                item = {
                  activation_label = {
                    h_align = "fill";
                    v_align = "fill";
                    width = 20;
                    x_align = 0.5;
                    y_align = 0.5;
                  };
                  icon = {
                    pixel_size = 26;
                    theme = "";
                  };
                };
                margins = {
                  top = 8;
                };
              };
            };
            search = {
              prompt = {
                name = "prompt";
                icon = "edit-find";
                theme = "";
                pixel_size = 18;
                h_align = "center";
                v_align = "center";
              };
              clear = {
                name = "clear";
                icon = "edit-clear";
                theme = "";
                pixel_size = 18;
                h_align = "center";
                v_align = "center";
              };
              input = {
                h_align = "fill";
                h_expand = true;
                icons = true;
              };
              spinner = {
                hide = true;
              };
            };
          };
        };
      };
    };
    # theme.style = ''
    #   @define-color foreground ${config.lib.stylix.colors.base05};
    #   @define-color background ${config.lib.stylix.colors.base00};
    #   @define-color accent ${config.lib.stylix.colors.base0E};
    #   #window, #box, #aiScroll, #aiList, #search, #password, #input, #prompt, #clear, #typeahead, #list, child, scrollbar, slider, #item, #text, #label, #bar, #sub, #activationlabel { all: unset; } #cfgerr { background: rgba(255, 0, 0, 0.4); margin-top: 20px; padding: 8px; font-size: 1.2em; } #window { color: @foreground; } #box { border-radius: 15px; background: @background; padding: 32px; border: 1px solid lighter(@background); box-shadow: 0 19px 38px rgba(0, 0, 0, 0.3), 0 15px 12px rgba(0, 0, 0, 0.22); } #search { box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.22); background: lighter(@background); border-radius: 15px; padding: 8px; } #prompt { margin-left: 4px; margin-right: 12px; color: @foreground; opacity: 0.2; } #clear { color: @foreground;opacity: 0.8; } #password, #input, #typeahead { border-radius: 2px; } #input { background: none; } #password { } #spinner { padding: 8px; } #typeahead { color: @foreground; opacity: 0.8; } #input placeholder { opacity: 0.5; } #list {} child { padding: 8px; border-radius: 2px; } child:selected, child:hover { background: alpha(@accent, 0.7); border-radius: 24px; } #item {} #icon { margin-right: 8px; } #text {} #label { font-weight: 500; } #sub { opacity: 0.5; font-size: 0.8em; }s #activationlabel {} #bar {} .barentry {} .activation #activationlabel {} .activation #text, .activation #icon, .activation #search { opacity: 0.5; }
    # '';
  };
}
