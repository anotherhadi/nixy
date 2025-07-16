# Mealie is a recipe management and meal planning application.
{config, ...}: let
  domain = "mealie.hadi.diy";
in {
  services = {
    mealie = {
      enable = true;
      port = 8092;
    };

    nginx.virtualHosts."${domain}" = {
      useACMEHost = "hadi.diy";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.mealie.port}";
      };
    };
  };
}
