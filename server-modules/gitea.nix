{ config, pkgs, lib, ... }:
let
  inherit (import ./mk-container.nix { inherit lib config; }) mkContainer;
  domain = config.var.domain;
  catppuccin-gitea = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
    sha256 = "sha256-rZHLORwLUfIFcB6K9yhrzr+UwdPNQVSadsw6rg8Q7gs=";
    stripRoot = false;
  };
in
{
  imports = [
    (mkContainer {
      name = "gitea";
      hostIp = "10.233.11.1";
      containerIp = "10.233.11.2";
      internet = true;
      bindMounts."/var/lib/gitea" = {
        hostPath = "/var/lib/gitea";
        isReadOnly = false;
      };
      nixosConfig = { lib, ... }: {
        users.users.gitea.uid = lib.mkForce 978;
        users.groups.gitea.gid = lib.mkForce 968;

        services.postgresql = {
          enable = true;
          ensureDatabases = [ "gitea" ];
          ensureUsers = [{
            name = "gitea";
            ensureDBOwnership = true;
          }];
        };

        services.gitea = {
          enable = true;
          database.type = "postgres";
          settings = {
            server = {
              HTTP_ADDR = "0.0.0.0";
              HTTP_PORT = 3002;
              ROOT_URL = "https://git.${domain}/";
              DOMAIN = "git.${domain}";
              LANDING_PAGE = "/anotherhadi";
            };
            service = {
              REGISTER_MANUAL_CONFIRM = true;
              DISABLE_REGISTRATION = true;
              DEFAULT_KEEP_EMAIL_PRIVATE = true;
              SHOW_REGISTRATION_BUTTON = false;
            };
            ui = {
              DEFAULT_THEME = "catppuccin-mocha-mauve";
              THEMES = "catppuccin-latte-mauve,catppuccin-frappe-mauve,catppuccin-macchiato-mauve,catppuccin-mocha-mauve";
            };
            explore = {
              DISABLE_USERS_PAGE = true;
              DISABLE_ORGANIZATIONS_PAGE = true;
            };
            repository.DISABLE_STARS = true;
            mailer.ENABLED = false;
            api.ENABLE_SWAGGER = false;
            other.SHOW_FOOTER_VERSION = false;
          };
        };

        systemd.services.gitea.preStart = lib.mkAfter ''
          mkdir -p /var/lib/gitea/custom/public/assets
          ln -sfn ${catppuccin-gitea} /var/lib/gitea/custom/public/assets/css
        '';

        networking.firewall.allowedTCPPorts = [ 3002 ];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."git.${domain}" = "http://10.233.11.2:3002";
}
