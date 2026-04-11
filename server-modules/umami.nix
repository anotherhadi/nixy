{ config, lib, ... }:
let
  inherit (import ./mk-container.nix { inherit lib config; }) mkContainer;
in
{
  sops.secrets.umami-secret.mode = "0400";

  imports = [
    (mkContainer {
      name = "umami";
      hostIp = "10.233.10.1";
      containerIp = "10.233.10.2";
      bindMounts."/run/secrets/umami-secret" = {
        hostPath = config.sops.secrets.umami-secret.path;
        isReadOnly = true;
      };
      nixosConfig = { ... }: {
        services.umami = {
          enable = true;
          settings = {
            PORT = 8080;
            HOSTNAME = "0.0.0.0";
            APP_SECRET_FILE = "/run/secrets/umami-secret";
            DISABLE_TELEMETRY = true;
            DISABLE_BOT_CHECK = true;
          };
        };
        # PrivateUsers breaks systemd-creds inside nspawn containers (nested user namespaces)
        systemd.services.umami.serviceConfig.PrivateUsers = lib.mkForce false;
        networking.firewall.allowedTCPPorts = [ 8080 ];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."umami.${config.var.domain}" = "http://10.233.10.2:8080";
}
