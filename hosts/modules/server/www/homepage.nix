{ pkgs, ... }:
let
  settings = ''
    {
      "config": {
        "title" : "Jack's Home",
        "openLinksInNewTab": false,
        "locale": "fr-FR",
        "colors": {
          "primary": "#89b4fa",
          "background": "#01010b",
          "foreground": "#cdd6f4",
          "muted": "#313244"
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
                "title": "Uptime Kuma",
                "url": "https://kuma.anotherhadi.com",
                "icon": "󱎫"
              }
            ]
          },
          {
            "name": "Admin",
            "links": [
              {
                "title": "Adguard Home",
                "url": "http://192.168.2.24:3001",
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
      rev = "6588787368cbc403cdec08fd25ef27b42077b8d3";
      hash = "sha256-Z2TZ56I6lRmYkLRnnMscvmSCzGt5q9yX90lGPebJpe8=";
    };

    npmDepsHash = "sha256-YxdrNTBbbgMHJ0WoSHePxdM7UJLbKsSbObW8M1uArUg=";

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
    enableACME = true;
    root = package + "/build";
  };
}
