{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (import ./mk-container.nix {inherit lib config;}) mkContainer;
  domain = config.var.domain;
in {
  imports = [
    (mkContainer {
      name = "def-creds";
      hostIp = "10.233.6.1";
      containerIp = "10.233.6.2";
      nixosConfig = {...}: {
        imports = [inputs.default-creds.nixosModules.default];
        services.default-creds = {
          enable = true;
          port = 8087;
        };
        networking.firewall.allowedTCPPorts = [8087];
        systemd.services.default-creds.environment = {
          HOST = lib.mkForce "0.0.0.0";
          PUBLIC_UMAMI_URL = "https://umami.${domain}";
          PUBLIC_UMAMI_WEBSITE_ID = "7197484c-01ad-488e-9caa-5ab7b7595f08";
          UMAMI_URL = "https://umami.${domain}";
          UMAMI_WEBSITE_ID = "7197484c-01ad-488e-9caa-5ab7b7595f08";
        };
        system.stateVersion = "24.05";
      };
    })
  ];

  services.default-creds.enable = lib.mkForce false;
  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."default-creds.${config.var.domain}" = "http://10.233.6.2:8087";
}
