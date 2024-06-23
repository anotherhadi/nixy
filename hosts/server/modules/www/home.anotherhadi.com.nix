{ pkgs, config, ... }:
let
  settings = ''
    {
      "config": {
        "title" : "Jack's Home",
        "openLinksInNewTab": false,
        "locale": "fr-FR",
        "colors": {
          "primary": "#${config.var.theme.colors.accent}",
          "background": "#${config.var.theme.colors.bg}",
          "foreground": "#${config.var.theme.colors.fg}",
          "muted": "#${config.var.theme.colors.c8}"
        },
        "folders": [
          {
            "name": "Home",
            "links": [
              {
                "title": "Nextcloud",
                "url": "https://cloud.anotherhadi.com",
                "icon": "󰅟"
              },
              {
                "title": "Vaultwarden",
                "url": "https://vault.anotherhadi.com",
                "icon": ""
              },
              {
                "title": "Jellyfin",
                "url": "http://jack:8096",
                "icon": "󰅟"
              },
              {
                "title": "Overseerr",
                "url": "http://jack:8096",
                "icon": "󰅟"
              },
            ]
          },
          {
            "name": "Admin",
            "links": [
              {
                "title": "Uptime Kuma",
                "url": "https://kuma.anotherhadi.com",
                "icon": "󱎫"
              },
              {
                "title": "Adguard Home",
                "url": "http://jack:3001",
                "icon": "󰷱"
              },
              {
                "title": "Proxmox",
                "url": "https://192.168.2.17:8006",
                "icon": ""
              },
              {
                "title": "Cloudflare",
                "url": "https://dash.cloudflare.com/",
                "icon": ""
              },
              {
                "title": "Tailscale",
                "url": "https://login.tailscale.com/admin/machines",
                "icon": "󰖂"
              }
            ]
          }
        ]
      }
    }
  '';

  package = pkgs.buildNpmPackage {
    pname = "homepage";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "anotherhadi";
      repo = "homepage";
      rev = "40286c5e03bcfb9993cce354b4f12c00a1b4966d";
      hash = "sha256-zlJ/bzFWE64HpUCxiRT5E9wrjVVwSTSgIOrifWKxphU=";
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
  services.nginx.virtualHosts."home.anotherhadi.com" = {
    serverAliases = [ "jack.anotherhadi.com" ];
    enableACME = true;
    root = package + "/build";
  };
}
