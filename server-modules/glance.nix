{ config, ... }:
let domain = "start.hadi.diy";
in {
  services = {
    glance = {
      enable = true;
      settings = {
        theme = {
          background-color = "200 11 5";
          primary-color = "217 91 75";
          contrast-multiplier = 1.3;
        };
        pages = [{
          columns = [
            {
              size = "small";
              widgets = [
                {
                  location = "Paris, France";
                  type = "weather";
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
                      icon = "si:adguardhome";
                    }
                  ];
                }
                {
                  type = "repository";
                  repository = "anotherhadi/nixy";
                  pull-requests-limit = 5;
                  issues-limit = 3;
                }
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
