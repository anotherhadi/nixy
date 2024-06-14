{ config, ... }: {

  imports = [ ./duckduckgo-colorscheme.nix ./homepage ];

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
      "gt" = "https://github.com/search?q={}&type=repositories";
    };

    quickmarks = {
      home = "${config.var.homeDirectory}/.config/startpage/index.html";
      server = "${config.var.homeDirectory}/.config/serverpage/index.html";
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
      cloudflare = "https://dash.cloudflare.com/";
    };

    settings = {
      url = {
        default_page =
          "${config.var.homeDirectory}/.config/startpage/index.html";
        start_pages =
          [ "${config.var.homeDirectory}/.config/startpage/index.html" ];
      };

      colors = {
        tabs = {
          odd.bg = "#${config.var.theme.colors.bg}";
          odd.fg = "#${config.var.theme.colors.fg}";
          even.bg = "#${config.var.theme.colors.bg}";
          even.fg = "#${config.var.theme.colors.fg}";
          selected = {
            odd = {
              bg = "#${config.var.theme.colors.accent}";
              fg = "#${config.var.theme.colors.accentFg}";
            };
            even = {
              bg = "#${config.var.theme.colors.accent}";
              fg = "#${config.var.theme.colors.accentFg}";
            };
          };
          indicator = {
            error = "#${config.var.theme.colors.c1}";
            start = "#${config.var.theme.colors.bgalt}";
            stop = "#${config.var.theme.colors.bgalt}";
          };
        };

        hints = {
          bg = "#${config.var.theme.colors.bgalt}";
          fg = "#${config.var.theme.colors.fgalt}";
          match.fg = "#${config.var.theme.colors.bg}";
        };

        completion = {
          category = {
            bg = "#${config.var.theme.colors.bg}";
            fg = "#${config.var.theme.colors.fg}";
            border = {
              top = "#${config.var.theme.colors.bg}";
              bottom = "#${config.var.theme.colors.bg}";
            };
          };

          odd.bg = "#${config.var.theme.colors.bg}";
          even.bg = "#${config.var.theme.colors.bg}";

          fg = [ "#FFFFFF" "#FFFFFF" "#FFFFFF" ];

          match.fg = "#${config.var.theme.colors.accent}";

          item.selected = {
            bg = "#${config.var.theme.colors.accent}";
            border.top = "#${config.var.theme.colors.accent}";
            border.bottom = "#${config.var.theme.colors.accent}";
            fg = "#${config.var.theme.colors.accentFg}";
            match.fg = "#${config.var.theme.colors.accentFg}";
          };
        };

        statusbar = {
          normal.bg = "#${config.var.theme.colors.bg}";
          normal.fg = "#${config.var.theme.colors.fg}";
          private.bg = "#${config.var.theme.colors.bg}";
          private.fg = "#${config.var.theme.colors.fg}";
          insert.bg = "#${config.var.theme.colors.accent}";
          insert.fg = "#${config.var.theme.colors.accentFg}";
          command = {
            bg = "#${config.var.theme.colors.bgalt}";
            fg = "#${config.var.theme.colors.fgalt}";
            private.bg = "#${config.var.theme.colors.bgalt}";
            private.fg = "#${config.var.theme.colors.fgalt}";
          };
        };

        messages = {
          info = {
            bg = "#${config.var.theme.colors.bgalt}";
            fg = "#${config.var.theme.colors.fgalt}";
            border = "#${config.var.theme.colors.bgalt}";
          };

          error = {
            bg = "#${config.var.theme.colors.c1}";
            fg = "#${config.var.theme.colors.fgalt}";
            border = "#${config.var.theme.colors.c1}";
          };
        };

        #webpage.darkmode.enabled = true; # Enable dark mode for all websites (Weird on images)
        webpage.preferred_color_scheme =
          "dark"; # Enable dark mode for websites that support it
      };

      fonts = { default_family = "${config.var.theme.font}"; };

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
        javascript.enabled = true;
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

      qt.force_software_rendering = "chromium";
    };

    keyBindings = {
      normal = {
        "gh" = "open ${config.var.homeDirectory}/.config/startpage/index.html";
        "gs" = "open ${config.var.homeDirectory}/.config/serverpage/index.html";

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
