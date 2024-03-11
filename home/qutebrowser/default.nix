{
  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      "DEFAULT" = "https://google.com/search?q={}";
      "yt" = "https://youtube.com/results?search_query={}";
      "nixo" = "https://search.nixos.org/options?channel=unstable&query={}";
      "nixp" = "https://search.nixos.org/packages?channel=unstable&query={}";
    };

    settings = {

      colors = {
        tabs = {
          odd.bg = "#000000";
          odd.fg = "#FFFFFF";
          even.bg = "#000000";
          even.fg = "#FFFFFF";
          selected.odd.bg = "#101012";
          selected.odd.fg = "#FFFFFF";
          selected.even.bg = "#101012";
          selected.even.fg = "#FFFFFF";
          indicator.error = "#101012";
          indicator.start = "#101012";
          indicator.stop = "#101012";
        };

        hints = {
          bg = "#101012";
          fg = "#FFFFFF";
          match.fg = "#E2E2E2";
        };

        completion = {
          category.bg = "#101012";
          category.fg = "#FFFFFF";
          category.border.top = "#101012";
          category.border.bottom = "#101012";

          odd.bg = "#101012";
          even.bg = "#101012";

          fg = [ "#FFFFFF" "#FFFFFF" "#FFFFFF" ];

          match.fg = "#FF0000";

          item.selected.bg = "#FF0000";
          item.selected.border.top = "#FF0000";
          item.selected.border.bottom = "#FF0000";
          item.selected.fg = "#FBFBFB";
          item.selected.match.fg = "#FBFBFB";
        };

        #        statusbar = {
        #          normal.bg = colors.statusbar.bg;
        #          normal.fg = colors.statusbar.fg;
        #          private.bg = colors.statusbar.private.bg;
        #          private.fg = colors.statusbar.private.fg;
        #          command = {
        #            bg = colors.statusbar.bg;
        #            fg = colors.statusbar.fg;
        #            private.bg = colors.statusbar.private.bg;
        #            private.fg = colors.statusbar.private.fg;
        #          };
        #        };
        #
        #        messages = {
        #          info = {
        #            bg = colors.statusbar.bg;
        #            fg = colors.statusbar.fg;
        #            border = colors.statusbar.bg;
        #          };
        #
        #          error = {
        #            bg = colors.messages.error.bg;
        #            fg = colors.messages.error.fg;
        #            border = colors.messages.error.bg;
        #          };
        #        };
      };

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

      url = {
        default_page = "https://duckduckgo.com";
        start_pages = [ "https://duckduckgo.com" ];
      };

      zoom.default = "130%";
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
