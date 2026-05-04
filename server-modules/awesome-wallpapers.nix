{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (import ./mk-container.nix {inherit lib config;}) mkContainer;
in {
  imports = [
    (mkContainer {
      name = "wallpapers";
      hostIp = "10.233.4.1";
      containerIp = "10.233.4.2";
      nixosConfig = {pkgs, ...}: {
        services.nginx = {
          enable = true;
          virtualHosts."wallpapers" = {
            root = "${inputs.awesome-wallpapers.packages.${pkgs.system}.default}/share/awesome-wallpapers";
            listen = [
              {
                addr = "0.0.0.0";
                port = 8080;
              }
            ];
            locations."/" = {
              tryFiles = "$uri $uri/ /index.html";
            };
            extraConfig = ''
              port_in_redirect off;
              absolute_redirect off;
            '';
          };
        };
        networking.firewall.allowedTCPPorts = [8080];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."wallpapers.${config.var.domain}" = "http://10.233.4.2:8080";
}
