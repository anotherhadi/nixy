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
      name = "iky-prod";
      hostIp = "10.233.1.1";
      containerIp = "10.233.1.2";
      internet = true;
      bindMounts."/etc/iky/config.yaml" = {
        hostPath = "/var/lib/iknowyou-prod/config.yaml";
        isReadOnly = false;
      };
      nixosConfig = {...}: {
        imports = [inputs.iknowyou.nixosModules.default];
        users.users.iknowyou.uid = 999;
        users.groups.iknowyou.gid = 999;
        services.iknowyou = {
          enable = true;
          port = 8080;
          openFirewall = true;
        };
        system.stateVersion = "24.05";
      };
    })

    (mkContainer {
      name = "iky-demo";
      hostIp = "10.233.2.1";
      containerIp = "10.233.2.2";
      nixosConfig = {...}: {
        imports = [inputs.iknowyou.nixosModules.default];
        services.iknowyou = {
          enable = true;
          port = 8080;
          openFirewall = true;
        };
        systemd.services.iknowyou.environment.IKY_DEMO = "true";
        system.stateVersion = "24.05";
      };
    })
  ];

  users.users.iknowyou = {
    isSystemUser = true;
    group = "iknowyou";
    uid = 999;
  };
  users.groups.iknowyou.gid = 999;

  systemd.tmpfiles.rules = [
    "f /var/lib/iknowyou-prod/config.yaml 0600 iknowyou iknowyou -"
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress = {
    "iknowyou-prod.${config.var.domain}" = "http://10.233.1.2:8080";
    "iknowyou.${config.var.domain}" = "http://10.233.2.2:8080";
  };
}
