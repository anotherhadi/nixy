{config, ...}: let
  inherit (config.flake.lib) mkContainer;
in {
  flake.modules.nixos.cyberchef = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      (mkContainer config {
        name = "cyberchef";
        hostIp = "10.233.5.1";
        containerIp = "10.233.5.2";
        nixosConfig = {...}: {
          services.nginx = {
            enable = true;
            virtualHosts."cyberchef" = {
              root = "${pkgs.unstable.cyberchef}/share/cyberchef";
              listen = [
                {
                  addr = "0.0.0.0";
                  port = 8080;
                }
              ];
            };
          };
          networking.firewall.allowedTCPPorts = [8080];
          system.stateVersion = "24.05";
        };
      })
    ];

    services.cloudflared.tunnels."${config.nixy.server.tunnelId}".ingress."cyberchef.${config.nixy.server.domain}" = "http://10.233.5.2:8080";
  };
}
