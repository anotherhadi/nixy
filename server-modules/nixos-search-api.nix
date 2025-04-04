{ config, ... }:
let domain = "search-nixos-api.hadi.diy";
in {
  services = {
    nixos-search-api = {
      enable = true;
      port = 8089;
    };

    nginx.virtualHosts."${domain}" = {
      useACMEHost = "hadi.diy";
      forceSSL = true;
      locations."/" = {
        proxyPass =
          "http://127.0.0.1:${toString config.services.nixos-search-api.port}";
      };
    };
  };
}
