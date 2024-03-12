{ config, ... }: {

  imports = [ ./duckduckgo-colorscheme.nix ];

  programs.qutebrowser = {
    enable = true;

    searchEngines = {
      "DEFAULT" = "https://duckduckgo.com/?q={}&ia=web";
      "d" = "https://duckduckgo.com/?q={}&ia=web";
      "g" = "https://google.com/search?q={}";
      "y" = "https://youtube.com/results?search_query={}";
      "n" = "https://mynixos.com/search?q={}";
      "nixo" = "https://search.nixos.org/options?channel=unstable&query={}";
      "nixp" = "https://search.nixos.org/packages?channel=unstable&query={}";
    };

    settings = {

      url = {
        default_page = "https://duckduckgo.com";
        start_pages = [ "https://duckduckgo.com" ];
      };

      colors = {
        tabs = {
          odd.bg = "#${config.theme.colors.bg}";
          odd.fg = "#${config.theme.colors.fg}";
          even.bg = "#${config.theme.colors.bg}";
          even.fg = "#${config.theme.colors.fg}";
          selected.odd.bg = "#${config.theme.colors.primary-bg}";
          selected.odd.fg = "#${config.theme.colors.primary-fg}";
          selected.even.bg = "#${config.theme.colors.primary-bg}";
          selected.even.fg = "#${config.theme.colors.primary-fg}";
          indicator.error = "#${config.theme.colors.color1}";
          indicator.start = "#${config.theme.colors.alt-bg}";
          indicator.stop = "#${config.theme.colors.alt-bg}";
        };

        hints = {
          bg = "#${config.theme.colors.alt-bg}";
          fg = "#${config.theme.colors.alt-fg}";
          match.fg = "#${config.theme.colors.bg}";
        };

        completion = {
          category.bg = "#${config.theme.colors.bg}";
          category.fg = "#${config.theme.colors.fg}";
          category.border.top = "#${config.theme.colors.bg}";
          category.border.bottom = "#${config.theme.colors.bg}";

          odd.bg = "#${config.theme.colors.bg}";
          even.bg = "#${config.theme.colors.bg}";

          fg = [ "#FFFFFF" "#FFFFFF" "#FFFFFF" ];

          match.fg = "#${config.theme.colors.primary-bg}";

          item.selected.bg = "#${config.theme.colors.primary-bg}";
          item.selected.border.top = "#${config.theme.colors.primary-bg}";
          item.selected.border.bottom = "#${config.theme.colors.primary-bg}";
          item.selected.fg = "#${config.theme.colors.primary-fg}";
          item.selected.match.fg = "#${config.theme.colors.primary-fg}";
        };

        statusbar = {
          normal.bg = "#${config.theme.colors.bg}";
          normal.fg = "#${config.theme.colors.fg}";
          private.bg = "#${config.theme.colors.bg}";
          private.fg = "#${config.theme.colors.fg}";
          command = {
            bg = "#${config.theme.colors.alt-bg}";
            fg = "#${config.theme.colors.alt-fg}";
            private.bg = "#${config.theme.colors.alt-bg}";
            private.fg = "#${config.theme.colors.alt-fg}";
          };
        };

        messages = {
          info = {
            bg = "#${config.theme.colors.alt-bg}";
            fg = "#${config.theme.colors.alt-fg}";
            border = "#${config.theme.colors.alt-bg}";
          };

          error = {
            bg = "#${config.theme.colors.color1}";
            fg = "#${config.theme.colors.alt-fg}";
            border = "#${config.theme.colors.color1}";
          };
        };
      };

      fonts = { default_family = "#${config.theme.font}"; };

      completion = {
        height = "30%";
        open_categories = [ "history" ];
        scrollbar = {
          padding = 0;
          width = 0;
        };
        show = "always";
        shrink = true;
        timestamp_format = "";
        web_history.max_items = 7;
      };

      content = {
        autoplay = false;
        javascript.clipboard = "access";
        pdfjs = true;
      };

      downloads = {
        position = "bottom";
        remove_finished = 0;
      };

      fileselect = {
        handler = "external";
        multiple_files.command = [
          "alacritty"
          "--embed"
          "$(xdotool getactivewindow)"
          "-e"
          "lf"
          "-selection-path"
          "{}"
        ];
        single_file.command = [
          "alacritty"
          "--embed"
          "$(xdotool getactivewindow)"
          "-e"
          "lf"
          "-selection-path"
          "{}"
        ];
      };

      hints = {
        border = "none";
        radius = 1;
      };

      scrolling = {
        bar = "never";
        smooth = true;
      };

      statusbar = {
        show = "never";
        widgets = [ ];
      };

      tabs = {
        show = "multiple";
        last_close = "close";
        mode_on_change = "restore";
        close_mouse_button = "right";
      };

      zoom.default = "100%";
    };

    keyMappings = {
      "<Super-l>" = "o";
      "<Super-t>" = "O";
    };

    keyBindings = {
      normal = {
        ",p" = "tab-move -";
        ",n" = "tab-move +";

        "<Super-r>" = "config-source";

        "<Super-c>" = "fake-key <Ctrl-c>";

        "<Super-Up>" = "scroll-to-perc 0";
        "<Super-Down>" = "scroll-to-perc";
        "<Super-Left>" = "back";
        "<Super-Right>" = "forward";

        "<Super-n>" = "open -w";
        "<Super-Shift-p>" = "open -p";

        "<Super-w>" = "tab-close";
        "<Super-1>" = "tab-focus 1";
        "<Super-2>" = "tab-focus 2";
        "<Super-3>" = "tab-focus 3";
        "<Super-4>" = "tab-focus 4";
        "<Super-5>" = "tab-focus 5";
        "<Super-6>" = "tab-focus 6";
        "<Super-7>" = "tab-focus 7";
        "<Super-8>" = "tab-focus 8";
        "<Super-9>" = "tab-focus 9";
        "<Super-0>" = "tab-focus 10";

        "gtb" = "open https://github.com/noib3";
        "ttb" = "open -t https://github.com/noib3";

        "gma" = "open https://mail.protonmail.com/inbox";
        "tma" = "open -t https://mail.protonmail.com/inbox";

        "gkp" = "open https://keep.google.com";
        "tkp" = "open -t https://keep.google.com";

        "grhm" =
          "open https://github.com/nix-community/home-manager/find/master";
        "trhm" =
          "open -t https://github.com/nix-community/home-manager/find/master";

        "gnv" = "open https://github.com/neovim/neovim/tree/master/src/nvim";
        "tnv" = "open -t https://github.com/neovim/neovim/tree/master/src/nvim";

        "gbg" = "open https://rarbgunblocked.org/torrents.php";
        "tbg" = "open -t https://rarbgunblocked.org/torrents.php";

        "g12ft" = "open https://12ft.io/";
        "t12ft" = "open -t https://12ft.io/";

        "gtra" = "open http://localhost:9091/transmission/web/";
        "ttra" = "open -t http://localhost:9091/transmission/web/";
      };

      command = {
        "<Super-w>" = "tab-close";

        "<Super-c>" = "completion-item-yank";
        "<Super-v>" = "fake-key --global <Ctrl-v>";

        "<Super-Left>" = "rl-beginning-of-line";
        "<Super-Right>" = "rl-end-of-line";
        "<Alt-Backspace>" = "rl-backward-kill-word";
        "<Super-Backspace>" = "rl-unix-line-discard";
      };

      insert = {
        "<Super-w>" = "tab-close";

        "<Super-c>" = "fake-key <Ctrl-c>";
        "<Super-v>" = "fake-key <Ctrl-v>";
        "<Super-x>" = "fake-key <Ctrl-x>";
        "<Super-z>" = "fake-key <Ctrl-z>";

        "<Super-Left>" = "fake-key <Home>";
        "<Super-Right>" = "fake-key <End>";
        "<Alt-Backspace>" = "fake-key <Ctrl-Backspace>";
        "<Super-Backspace>" = "fake-key <Shift-Home><Delete>";

        "<Super-1>" = "tab-focus 1";
        "<Super-2>" = "tab-focus 2";
        "<Super-3>" = "tab-focus 3";
        "<Super-4>" = "tab-focus 4";
        "<Super-5>" = "tab-focus 5";
        "<Super-6>" = "tab-focus 6";
        "<Super-7>" = "tab-focus 7";
        "<Super-8>" = "tab-focus 8";
        "<Super-9>" = "tab-focus 9";
        "<Super-0>" = "tab-focus 10";
      };
    };

    extraConfig = ''
      config.unbind("gm")
      config.unbind("gd")
      config.unbind("gb")
      config.unbind("tl")
      config.unbind("gt")

      c.tabs.padding = {"bottom": 0, "left": 7, "right": 7, "top": 0}

      config.load_autoconfig(True)
    '';
  };
}
