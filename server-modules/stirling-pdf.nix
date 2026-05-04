{
  config,
  lib,
  ...
}: let
  inherit (import ./mk-container.nix {inherit lib config;}) mkContainer;
in {
  imports = [
    (mkContainer {
      name = "stirling-pdf";
      hostIp = "10.233.9.1";
      containerIp = "10.233.9.2";
      nixosConfig = {...}: {
        services.stirling-pdf = {
          enable = true;
          environment."SERVER_PORT" = "8080";
        };
        networking.firewall.allowedTCPPorts = [8080];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."pdf.${config.var.domain}" = "http://10.233.9.2:8080";
}
