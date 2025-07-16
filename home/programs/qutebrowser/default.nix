# Qutebrowser is a keyboard-focused browser with a minimal GUI.
# My homepage is generated using https://github.com/anotherhadi/homepage
# Legacy
{
  pkgs,
  config,
  ...
}: let
  accent = "#${config.lib.stylix.colors.base0D}";
  background = "#${config.lib.stylix.colors.base00}";
  foreground = "#${config.lib.stylix.colors.base05}";
  muted = "#${config.lib.stylix.colors.base03}";

  settings = ''
    {
      "config": {
        "title" : "Welcome Home",
        "openLinksInNewTab": false,
        "locale": "fr-FR",
        "colors": {
          "primary": "${accent}",
          "background": "${background}",
          "foreground": "${foreground}",
          "muted": "#${muted}"
        },
        "folders": [
          {
            "name": "Bookmarks",
            "links": [
              {"title": "MyNixOs", "url": "https://mynixos.com", "icon": "󱄅"},
              {"title": "Github", "url": "https://github.com", "icon": ""},
              {"title": "Proton", "url": "https://mail.proton.me/u/0/inbox", "icon": ""},
              {"title": "Cloudflare One", "url": "https://one.dash.cloudflare.com/", "icon": ""},
              {"title": "Chat GPT", "url": "https://chat.openai.com/", "icon": "󰭹"},
              {"title": "Nixvim", "url": "https://nix-community.github.io/nixvim/", "icon": ""},
              {"title": "Hyprland Wiki", "url": "https://wiki.hyprland.org/", "icon": "󰖬"},
              {"title": "Youtube", "url": "https://youtube.com", "icon": "󰗃"},
              {"title": "Figma", "url": "https://figma.com", "icon": ""},
              {"title": "Server", "url": "https://home.anotherhadi.com", "icon": ""}
            ]
          },
          {
            "name": "Work",
            "links": [
              {"title": "Outlook", "url": "https://outlook.office.com/mail/", "icon": "󰴢"},
              {"title": "Office", "url": "https://www.office.com/?auth=2", "icon": "󰏆"},
              {"title": "Teams", "url": "https://teams.microsoft.com/_", "icon": "󰊻"}
            ]
          }
        ]
      }
    }
  '';

  homepage = pkgs.buildNpmPackage {
    pname = "homepage";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "anotherhadi";
      repo = "homepage";
      rev = "b77d35ed3596eb451bd2ec78063d7cc6e73c773d";
      hash = "sha256-j/40922kfAh6zqJ4IRYpr66YXNNYsxuXwZ0aiJFJea0=";
    };

    # npmDepsHash = lib.fakeHash;
    npmDepsHash = "sha256-bG+CHTq2Rst3JMxsjAC81KhK+G7WwsTVD1eyP87g0z4=";

    buildPhase = ''
      npm install
      cp ${
        pkgs.writeText "src/routes/config.json" settings
      } src/routes/config.json
      npm run build
      mkdir $out
      mv build $out
    '';

    meta = {
      description = "homepage";
      homepage = "https://github.com/anotherhadi/homepage";
    };
  };
in {
  imports = [../duckduckgo-colorscheme];

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
      home = "${homepage}/build/index.html";
      server = "https://home.anotherhadi.com";
      jack = "https://home.anotherhadi.com";
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
        default_page = "${homepage}/build/index.html";
        start_pages = ["${homepage}/build/index.html"];
      };

      colors = {
        webpage.preferred_color_scheme = "dark"; # Enable dark mode for websites that support it
      };

      statusbar.show = "in-mode";

      completion = {
        height = "30%";
        open_categories = ["history"];
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
        webgl = true;
        pdfjs = true;
      };

      downloads = {
        position = "bottom";
        remove_finished = 0;
      };

      hints = {radius = 1;};

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
        "gh" = "open ${homepage}/build/index.html";
        "gs" = "open https://home.anotherhadi.com";

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
      c.statusbar.padding = {"bottom": 6, "left": 7, "right": 7, "top": 6}

      config.load_autoconfig(True)
    '';
  };
}
