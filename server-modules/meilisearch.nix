{ config, ... }:
let domain = "meilisearch.hadi.diy";
in {
  services = {
    meilisearch = {
      enable = true;
      listenPort = 7700;
      # masterKeyEnvironmentFile= "";
    };
    nginx.virtualHosts."${domain}" = {
      useACMEHost = "hadi.diy";
      forceSSL = true;
      locations."/" = {
        proxyPass =
          "http://127.0.0.1:${toString config.services.meilisearch.listenPort}";
      };
    };
  };
}
