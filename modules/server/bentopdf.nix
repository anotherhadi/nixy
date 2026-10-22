{config, ...}: let
  inherit (config.flake.lib) mkContainer;
in {
  flake.modules.nixos.bentopdf = {config, ...}: {
    imports = [
      (mkContainer config {
        name = "bentopdf";
        hostIp = "10.233.9.1";
        containerIp = "10.233.9.2";
        nixosConfig = {...}: {
          services.bentopdf = {
            enable = true;
            domain = "bentopdf";
            nginx = {
              enable = true;
              virtualHost.listen = [
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

    services.cloudflared.tunnels."${config.nixy.server.tunnelId}".ingress."pdf.${config.nixy.server.domain}" = "http://10.233.9.2:8080";
  };
}
