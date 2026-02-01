# Glance is a self-hosted homepage/dashboard service.
{
  config,
  lib,
  ...
}: {
  imports = [./home.nix ./server.nix];

  services = {
    glance = {
      enable = true;
      settings = {
        # theme.contrast-multiplier = lib.mkForce 1.4;
        server.port = 5678;
      };
    };
    cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress = {
      "start.hadi.diy" = "http://localhost:${toString config.services.glance.settings.server.port}";
      "home.hadi.diy" = "http://localhost:${toString config.services.glance.settings.server.port}";
      "glance.hadi.diy" = "http://localhost:${toString config.services.glance.settings.server.port}";
    };
  };

  systemd.services.glance.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "glance";
    Group = "glance";
  };

  users = {
    groups.glance = {};
    users.glance = {
      isSystemUser = true;
      description = "Glance user";
      group = "glance";
    };
  };

  sops.secrets.adguard-pwd = {
    owner = "glance";
    mode = "0600";
  };
}
