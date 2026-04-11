{ config, lib, ... }:
let
  inherit (import ./mk-container.nix { inherit lib config; }) mkContainer;
in
{
  imports = [
    (mkContainer {
      name = "mealie";
      hostIp = "10.233.8.1";
      containerIp = "10.233.8.2";
      internet = true;
      nixosConfig = { ... }: {
        services.mealie = {
          enable = true;
          port = 8080;
        };
        networking.firewall.allowedTCPPorts = [ 8080 ];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."mealie.${config.var.domain}" = "http://10.233.8.2:8080";
}
