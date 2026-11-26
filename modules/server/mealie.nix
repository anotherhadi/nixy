# Mealie is a recipe manager and meal planner
{config, ...}: let
  inherit (config.flake.lib) mkContainer;
in {
  flake.modules.nixos.mealie = {config, ...}: let
    domain = config.nixy.server.domain;
  in {
    imports = [
      (mkContainer config {
        name = "mealie";
        hostIp = "10.233.16.1";
        containerIp = "10.233.16.2";
        # Scrape recipes from websites
        internet = true;
        nixosConfig = {...}: {
          services.mealie = {
            enable = true;
            listenAddress = "0.0.0.0";
            port = 9000;
            settings = {
              BASE_URL = "https://mealie.${domain}";
              ALLOW_SIGNUP = "false";
            };
          };
          networking.firewall.allowedTCPPorts = [9000];
          system.stateVersion = "24.05";
        };
      })
    ];

    services.cloudflared.tunnels."${config.nixy.server.tunnelId}".ingress."mealie.${domain}" = "http://10.233.16.2:9000";
  };
}
