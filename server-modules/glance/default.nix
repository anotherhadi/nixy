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
      "start.hadi.diy" = "http://localhost:8755";
      "home.hadi.diy" = "http://localhost:8755";
      "glance.hadi.diy" = "http://localhost:8755";
    };

    nginx.virtualHosts."glance.local" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8755;
        }
      ];
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.glance.settings.server.port}";
        extraConfig = ''
          proxy_cache_valid 200 30m;
          proxy_cache_use_stale error timeout updating http_500 http_502 http_503 http_504;
          add_header X-Cache-Status $upstream_cache_status;
        '';
      };
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
