# Custom NixOS module for the Search NixOS API service
# Check https://search-nixos.hadi.diy
{config, ...}: let
  domain = "search-nixos-api.hadi.diy";
in {
  services = {
    search-nixos-api = {enable = true;};

    nginx.virtualHosts."${domain}" = {
      useACMEHost = "hadi.diy";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.search-nixos-api.port}/";
      };
    };
  };
}
