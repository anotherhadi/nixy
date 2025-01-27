{ pkgs, config, inputs, ... }:
let
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
  home.file.".config/homepage" = {
    source = "${homepage}/build";
    recursive = true;
  };

  home.packages = with pkgs;
    [ inputs.zen-browser.packages."${system}".default ];
}
