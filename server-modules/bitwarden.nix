# Bitwarden (or vaultwarden) is a self-hosted password manager.
{config, ...}: let
  domain = "vault.hadi.diy";
in {
  services = {
    vaultwarden = {
      enable = true;
      config = {
        DOMAIN = "https://" + domain;
        SIGNUPS_ALLOWED = true;
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";
      };
    };

    nginx.virtualHosts."${domain}" = {
      useACMEHost = "hadi.diy";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${
          toString config.services.vaultwarden.config.ROCKET_PORT
        }";
      };
    };
  };
}
