{ config, lib, ... }:
let
  domain = "start.hadi.diy";

  rgb-to-hsl = color:
    let
      r = ((lib.toInt config.lib.stylix.colors."${color}-rgb-r") * 100.0) / 255;
      g = ((lib.toInt config.lib.stylix.colors."${color}-rgb-g") * 100.0) / 255;
      b = ((lib.toInt config.lib.stylix.colors."${color}-rgb-b") * 100.0) / 255;
      max = lib.max r (lib.max g b);
      min = lib.min r (lib.min g b);
      delta = max - min;
      fmod = base: int: base - (int * builtins.floor (base / int));
      h = if delta == 0 then
        0
      else if max == r then
        60 * (fmod ((g - b) / delta) 6)
      else if max == g then
        60 * (((b - r) / delta) + 2)
      else if max == b then
        60 * (((r - g) / delta) + 4)
      else
        0;
      l = (max + min) / 2;
      s = if delta == 0 then
        0
      else
        100 * delta / (100 - lib.max (2 * l - 100) (100 - (2 * l)));
      roundToString = value: toString (builtins.floor (value + 0.5));
    in lib.concatMapStringsSep " " roundToString [ h s l ];
in {
  services = {
    glance = {
      enable = true;
      settings = {
        theme = {
          background-color = rgb-to-hsl "base00";
          primary-color = rgb-to-hsl "base0D";
          positive-color = rgb-to-hsl "base01";
          negative-color = rgb-to-hsl "base04";
          contrast-multiplier = 1.4;
        };
        pages = [{
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
                      chart-link =
                        "https://www.tradingview.com/chart/?symbol=INDEX:BTCUSD";
                    }
                    {
                      symbol = "SOL-USD";
                      name = "Solana";
                      chart-link =
                        "https://www.tradingview.com/chart/?symbol=INDEX:SOLUSD";
                    }
                    {
                      symbol = "ETH-USD";
                      name = "Ethereum";
                      chart-link =
                        "https://www.tradingview.com/chart/?symbol=INDEX:ETHUSD";
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
                  type = "server-stats";
                  servers = [{
                    type = "local";
                    name = "Jack";
                  }];
                }
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
                      title = "Hoarder";
                      url = "https://hoarder.hadi.diy";
                      icon = "si:bookstack";
                    }
                  ];
                }
                {
                  type = "repository";
                  repository = "anotherhadi/nixy";
                  pull-requests-limit = 5;
                  issues-limit = 3;
                }
                { type = "hacker-news"; }
              ];
            }
          ];
          name = "Home";
        }];
        server = { port = 5678; };
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
}
