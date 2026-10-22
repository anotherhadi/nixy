{config, ...}: let
  inherit (config.flake.lib) mkContainer;
in {
  flake.modules.nixos.uptime-kuma = {config, ...}: {
    imports = [
      (mkContainer config {
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

    services.cloudflared.tunnels."${config.nixy.server.tunnelId}".ingress."uptime.${config.nixy.server.domain}" = "http://10.233.13.2:3001";
  };
}
