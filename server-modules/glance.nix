# Glance is a self-hosted homepage/dashboard service.
{
  config,
  lib,
  ...
}: let
  domain = "start.hadi.diy";

  rgb-to-hsl = color: let
    r = ((lib.toInt config.lib.stylix.colors."${color}-rgb-r") * 100.0) / 255;
    g = ((lib.toInt config.lib.stylix.colors."${color}-rgb-g") * 100.0) / 255;
    b = ((lib.toInt config.lib.stylix.colors."${color}-rgb-b") * 100.0) / 255;
    max = lib.max r (lib.max g b);
    min = lib.min r (lib.min g b);
    delta = max - min;
    fmod = base: int: base - (int * builtins.floor (base / int));
    h =
      if delta == 0
      then 0
      else if max == r
      then 60 * (fmod ((g - b) / delta) 6)
      else if max == g
      then 60 * (((b - r) / delta) + 2)
      else if max == b
      then 60 * (((r - g) / delta) + 4)
      else 0;
    l = (max + min) / 2;
    s =
      if delta == 0
      then 0
      else 100 * delta / (100 - lib.max (2 * l - 100) (100 - (2 * l)));
    roundToString = value: toString (builtins.floor (value + 0.5));
  in
    lib.concatMapStringsSep " " roundToString [h s l];
in {
  # TODO: Add tailscale custom widget
  services = {
    glance = {
      enable = true;
      settings = {
        theme = {
          contrast-multiplier = lib.mkForce 1.4;
        };
        pages = [
          {
            hide-desktop-navigation = true;
            columns = [
              {
                size = "small";
                widgets = [
                  {
                    type = "clock";
                    hour-format = "24h";
                  }
                  {
                    type = "weather";
                    location = "Paris, France";
                  }
                  {
                    type = "markets";
                    markets = [
                      {
                        symbol = "BTC-USD";
                        name = "Bitcoin";
                        chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:BTCUSD";
                      }
                      {
                        symbol = "SOL-USD";
                        name = "Solana";
                        chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:SOLUSD";
                      }
                      {
                        symbol = "ETH-USD";
                        name = "Ethereum";
                        chart-link = "https://www.tradingview.com/chart/?symbol=INDEX:ETHUSD";
                      }
                    ];
                  }
                  {
                    type = "dns-stats";
                    service = "adguard";
                    url = "https://adguard.hadi.diy";
                    username = "hadi";
                    password = "\${secret:adguard-pwd}";
                  }
                ];
              }
              {
                size = "full";
                widgets = [
                  {
                    type = "search";
                    search-engine = "duckduckgo";
                  }
                  {
                    type = "bookmarks";
                    groups = [
                      {
                        title = "";
                        same-tab = true;
                        color = "200 50 50";
                        links = [
                          {
                            title = "ProtonMail";
                            url = "https://proton.me/mail";
                          }
                          {
                            title = "Github";
                            url = "https://github.com";
                          }
                          {
                            title = "Youtube";
                            url = "https://youtube.com";
                          }
                          {
                            title = "Figma";
                            url = "https://figma.com";
                          }
                        ];
                      }
                      {
                        title = "Docs";
                        same-tab = true;
                        color = "200 50 50";
                        links = [
                          {
                            title = "Nixpkgs repo";
                            url = "https://github.com/NixOS/nixpkgs";
                          }
                          {
                            title = "Nixvim";
                            url = "https://nix-community.github.io/nixvim/";
                          }
                          {
                            title = "Hyprland wiki";
                            url = "https://wiki.hyprland.org/";
                          }
                          {
                            title = "Search NixOS";
                            url = "https://search-nixos.hadi.diy";
                          }
                        ];
                      }
                      {
                        title = "Homelab";
                        same-tab = true;
                        color = "100 50 50";
                        links = [
                          {
                            title = "Router";
                            url = "http://192.168.1.254/";
                          }
                          {
                            title = "Cloudflare";
                            url = "https://dash.cloudflare.com/";
                          }
                        ];
                      }
                      {
                        title = "Work";
                        same-tab = true;
                        color = "50 50 50";
                        links = [
                          {
                            title = "Outlook";
                            url = "https://outlook.office.com/";
                          }
                          {
                            title = "Teams";
                            url = "https://teams.microsoft.com/";
                          }
                          {
                            title = "Office";
                            url = "https://www.office.com/";
                          }
                        ];
                      }
                      {
                        title = "Cyber";
                        same-tab = true;
                        color = rgb-to-hsl "base09";
                        links = [
                          {
                            title = "CyberChef";
                            url = "https://cyberchef.org/";
                          }
                          {
                            title = "TryHackMe";
                            url = "https://tryhackme.com/";
                          }
                          {
                            title = "RootMe";
                            url = "https://www.root-me.org/";
                          }
                          {
                            title = "Exploit-DB";
                            url = "https://www.exploit-db.com/";
                          }
                          {
                            title = "CrackStation";
                            url = "https://crackstation.net/";
                          }
                        ];
                      }
                      {
                        title = "Misc";
                        same-tab = true;
                        color = rgb-to-hsl "base01";
                        links = [
                          {
                            title = "Svgl";
                            url = "https://svgl.app/";
                          }
                          {
                            title = "Excalidraw";
                            url = "https://excalidraw.com/";
                          }
                          {
                            title = "Cobalt (Downloader)";
                            url = "https://cobalt.tools/";
                          }
                          {
                            title = "Mazanoke (Image optimizer)";
                            url = "https://mazanoke.com/";
                          }
                          {
                            title = "Vert (File converter)";
                            url = "https://vert.sh/";
                          }
                        ];
                      }
                    ];
                  }
                  {
                    type = "server-stats";
                    servers = [
                      {
                        type = "local";
                        name = "Jack";
                      }
                    ];
                  }
                  {
                    type = "group";
                    widgets = [
                      {
                        type = "monitor";
                        title = "Services";
                        cache = "1m";
                        sites = [
                          {
                            title = "Vaultwarden";
                            url = "https://vault.hadi.diy";
                            icon = "si:bitwarden";
                          }
                          {
                            title = "Nextcloud";
                            url = "https://cloud.hadi.diy";
                            icon = "si:nextcloud";
                          }
                          {
                            title = "Adguard";
                            url = "https://adguard.hadi.diy";
                            icon = "si:adguard";
                          }
                          {
                            title = "Mealie";
                            url = "https://mealie.hadi.diy";
                            icon = "si:mealie";
                          }
                        ];
                      }
                      {
                        type = "monitor";
                        title = "*arr";
                        cache = "1m";
                        sites = [
                          {
                            title = "Jellyfin";
                            url = "https://jellyfin.hadi.diy";
                            icon = "si:jellyfin";
                          }
                          {
                            title = "Jellyseerr";
                            url = "https://jellyseerr.hadi.diy";
                            icon = "si:odysee";
                          }
                          {
                            title = "Radarr";
                            url = "https://radarr.hadi.diy";
                            icon = "si:radarr";
                          }
                          {
                            title = "Sonarr";
                            url = "https://sonarr.hadi.diy";
                            icon = "si:sonarr";
                          }
                          {
                            title = "Prowlarr";
                            url = "https://prowlarr.hadi.diy";
                            icon = "si:podcastindex";
                          }
                          {
                            title = "Transmission";
                            url = "https://transmission.hadi.diy";
                            icon = "si:transmission";
                          }
                        ];
                      }
                    ];
                  }
                ];
              }
            ];
            name = "Home";
          }
        ];
        server = {port = 5678;};
      };
    };
    nginx.virtualHosts."${domain}" = {
      useACMEHost = "hadi.diy";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${
          toString config.services.glance.settings.server.port
        }";
      };
    };
  };

  systemd.services.glance = {
    serviceConfig = {
      DynamicUser = lib.mkForce false;
      User = "glance";
      Group = "glance";
    };
  };

  users = {
    groups.glance = {};
    users.glance = {
      isSystemUser = true;
      description = "Glance user";
      group = "glance";
    };
  };

  sops.secrets.adguard-pwd = {
    owner = "glance";
    mode = "0600";
  };
}
