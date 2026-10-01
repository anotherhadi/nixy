{
  config,
  lib,
  ...
}: let
  inherit (import ./mk-container.nix {inherit lib config;}) mkContainer;
in {
  imports = [
    (mkContainer {
      name = "uptime-kuma";
      hostIp = "10.233.13.1";
      containerIp = "10.233.13.2";
      internet = true;
      nixosConfig = {...}: {
        services.uptime-kuma = {
          enable = true;
          settings = {
            HOST = "0.0.0.0";
            PORT = "3001";
          };
        };
        networking.firewall.allowedTCPPorts = [3001];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."uptime.${config.var.domain}" = "http://10.233.13.2:3001";
}
