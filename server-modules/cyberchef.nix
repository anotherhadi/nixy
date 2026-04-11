{ config, lib, ... }:
let
  inherit (import ./mk-container.nix { inherit lib config; }) mkContainer;
in
{
  imports = [
    (mkContainer {
      name = "cyberchef";
      hostIp = "10.233.5.1";
      containerIp = "10.233.5.2";
      nixosConfig = { pkgs, ... }: {
        services.nginx = {
          enable = true;
          virtualHosts."cyberchef" = {
            root = "${pkgs.cyberchef}/share/cyberchef";
            listen = [{ addr = "0.0.0.0"; port = 8080; }];
          };
        };
        networking.firewall.allowedTCPPorts = [ 8080 ];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."cyberchef.${config.var.domain}" = "http://10.233.5.2:8080";
}
