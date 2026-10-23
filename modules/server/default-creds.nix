{
  inputs,
  config,
  ...
}: let
  inherit (config.flake.lib) mkContainer;
in {
  flake.modules.nixos.default-creds = {
    config,
    lib,
    ...
  }: {
    imports = [
      inputs.default-creds-web.nixosModules.default
      (mkContainer config {
        name = "def-creds";
        hostIp = "10.233.6.1";
        containerIp = "10.233.6.2";
        internet = true;
        nixosConfig = {...}: {
          imports = [inputs.default-creds-web.nixosModules.default];
          services.default-creds-web = {
            enable = true;
            port = 8087;
          };
          networking.firewall.allowedTCPPorts = [8087];
          systemd.services.default-creds-web.environment = {
            HOST = lib.mkForce "0.0.0.0";
          };
          system.stateVersion = "24.05";
        };
      })
    ];

    services.cloudflared.tunnels."${config.nixy.server.tunnelId}".ingress."default-creds.${config.nixy.server.domain}" = "http://10.233.6.2:8087";
  };
}
