{ pkgs, config, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  background = "#${config.lib.stylix.colors.base00}";
  foreground = "#${config.lib.stylix.colors.base05}";
  muted = "#${config.lib.stylix.colors.base03}";

  settings = ''
        {
          "config": {
            "title" : "Jack",
            "openLinksInNewTab": true,
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
                  {"title": "Bitwarden", "url": "https://bw.anotherhadi.com", "icon": "󰟵"},
                  {"title": "CasaOS", "url": "https://casa.anotherhadi.com", "icon": "󰋜"}
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

  update-homepage = pkgs.writeShellScriptBin "update-homepage"
    # bash
    ''
      ssh jack@192.168.1.75 -S -C "sudo rm -rf /DATA/AppData/nginxproxymanager/data/homepage"
      scp -r ~/.config/serverhomepage/build jack@192.168.1.75:/DATA/AppData/nginxproxymanager/data/homepage
    '';
in {
  home.file.".config/serverhomepage" = { source = homepage; };

  home.packages = [ update-homepage ];
}
