{
  config,
  lib,
  ...
}: let
  inherit (import ./mk-container.nix {inherit lib config;}) mkContainer;
in {
  imports = [
    (mkContainer {
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

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."pdf.${config.var.domain}" = "http://10.233.9.2:8080";
}
