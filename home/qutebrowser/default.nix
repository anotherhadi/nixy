{ config, ... }: {

  imports = [ ./duckduckgo-colorscheme.nix ./homepage/default.nix ];

  programs.qutebrowser = {
    enable = true;

    searchEngines = {
      "DEFAULT" = "https://duckduckgo.com/?q={}&ia=web";
      "d" = "https://duckduckgo.com/?q={}&ia=web";
      "g" = "https://google.com/search?q={}";
      "y" = "https://youtube.com/results?search_query={}";
      "ya" = "https://yandex.com/search/?text={}";
      "n" = "https://mynixos.com/search?q={}";
      "nixo" = "https://search.nixos.org/options?channel=unstable&query={}";
      "nixp" = "https://search.nixos.org/packages?channel=unstable&query={}";
    };

    quickmarks = {
      home = "${config.home.homeDirectory}/.config/startpage/index.html";
      mynixos = "https://mynixos.com";
      github = "https://github.com";
      outlook = "https://outlook.office.com/mail/";
      office = "https://www.office.com/?auth=2";
      teams = "https://teams.microsoft.com/_";
      casa = "http://192.168.2.16:8081/#/";
      proton = "https://mail.proton.me/u/0/inbox";
      cloudflare-one = "https://one.dash.cloudflare.com/";
      chatgpt = "https://chat.openai.com/";
      nixvim = "https://nix-community.github.io/nixvim/";
      hyprland = "https://wiki.hyprland.org/";
      nerdfont = "https://www.nerdfonts.com/cheat-sheet";
      youtube = "https://youtube.com/";
    };

    settings = {
      url = {
        default_page =
          "${config.home.homeDirectory}/.config/startpage/index.html";
        start_pages =
          [ "${config.home.homeDirectory}/.config/startpage/index.html" ];
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
          insert.bg = "#${config.theme.colors.primary-bg}";
          insert.fg = "#${config.theme.colors.primary-fg}";
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

        #webpage.darkmode.enabled = true; # Enable dark mode for all websites (Weird on images)
        webpage.preferred_color_scheme =
          "dark"; # Enable dark mode for websites that support it
      };

      fonts = { default_family = "${config.theme.font}"; };

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

      hints = {
        border = "none";
        radius = 1;
      };

      scrolling = {
        bar = "never";
        smooth = true;
      };

      tabs = {
        show = "multiple";
        last_close = "close";
        mode_on_change = "restore";
        close_mouse_button = "right";
      };

      zoom.default = "100%";
    };

    keyBindings = {
      normal = {
        "gh" = "open ${config.home.homeDirectory}/.config/startpage/index.html";

        " p" = "tab-move -";
        " n" = "tab-move +";
        " w" = "tab-close";

        " 1" = "tab-focus 1";
        " 2" = "tab-focus 2";
        " 3" = "tab-focus 3";
        " 4" = "tab-focus 4";
        " 5" = "tab-focus 5";
        " 6" = "tab-focus 6";
        " 7" = "tab-focus 7";
        " 8" = "tab-focus 8";
        " 9" = "tab-focus 9";
        " 0" = "tab-focus 10";

        "<Ctrl-w>" = "tab-close";
        "<Ctrl-n>" = "open -w";

        "<Ctrl-1>" = "tab-focus 1";
        "<Ctrl-2>" = "tab-focus 2";
        "<Ctrl-3>" = "tab-focus 3";
        "<Ctrl-4>" = "tab-focus 4";
        "<Ctrl-5>" = "tab-focus 5";
        "<Ctrl-6>" = "tab-focus 6";
        "<Ctrl-7>" = "tab-focus 7";
        "<Ctrl-8>" = "tab-focus 8";
        "<Ctrl-9>" = "tab-focus 9";
        "<Ctrl-0>" = "tab-focus 10";
      };

      command = {
        "<Ctrl-w>" = "tab-close";
        "<Ctrl-n>" = "open -w";
        "<Ctrl-1>" = "tab-focus 1";
        "<Ctrl-2>" = "tab-focus 2";
        "<Ctrl-3>" = "tab-focus 3";
        "<Ctrl-4>" = "tab-focus 4";
        "<Ctrl-5>" = "tab-focus 5";
        "<Ctrl-6>" = "tab-focus 6";
        "<Ctrl-7>" = "tab-focus 7";
        "<Ctrl-8>" = "tab-focus 8";
        "<Ctrl-9>" = "tab-focus 9";
        "<Ctrl-0>" = "tab-focus 10";
      };

      insert = {
        "<Ctrl-w>" = "tab-close";
        "<Ctrl-n>" = "open -w";
        "<Ctrl-1>" = "tab-focus 1";
        "<Ctrl-2>" = "tab-focus 2";
        "<Ctrl-3>" = "tab-focus 3";
        "<Ctrl-4>" = "tab-focus 4";
        "<Ctrl-5>" = "tab-focus 5";
        "<Ctrl-6>" = "tab-focus 6";
        "<Ctrl-7>" = "tab-focus 7";
        "<Ctrl-8>" = "tab-focus 8";
        "<Ctrl-9>" = "tab-focus 9";
        "<Ctrl-0>" = "tab-focus 10";
      };
    };

    extraConfig = ''
      config.unbind("gm")
      config.unbind("gd")
      config.unbind("gb")
      config.unbind("tl")
      config.unbind("gt")

      c.tabs.padding = {"bottom": 6, "left": 7, "right": 7, "top": 6}

      config.load_autoconfig(True)
    '';
  };
}
