{
  config,
  lib,
  ...
}: let
  inherit (import ./mk-container.nix {inherit lib config;}) mkContainer;
  domain = config.var.domain;
in {
  imports = [
    (mkContainer {
      name = "miniflux";
      hostIp = "10.233.8.1";
      containerIp = "10.233.8.2";
      internet = true;
      bindMounts = {
        "/run/secrets/miniflux-admin-credentials" = {
          hostPath = config.sops.secrets.miniflux-admin-credentials.path;
          isReadOnly = true;
        };
      };
      nixosConfig = {...}: {
        services.miniflux = {
          enable = true;
          createDatabaseLocally = true;
          config = {
            LISTEN_ADDR = "0.0.0.0:8080";
            BASE_URL = "https://miniflux.${domain}";
          };
          adminCredentialsFile = "/run/secrets/miniflux-admin-credentials";
        };
        networking.firewall.allowedTCPPorts = [8080];
        system.stateVersion = "24.05";
      };
    })
  ];

  sops.secrets.miniflux-admin-credentials = {
    owner = "root";
    mode = "0400";
  };

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."miniflux.${domain}" = "http://10.233.8.2:8080";
}
