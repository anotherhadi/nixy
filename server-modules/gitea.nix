{
  config,
  pkgs,
  lib,
  ...
}: let
  catppuccin-gitea = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
    sha256 = "sha256-rZHLORwLUfIFcB6K9yhrzr+UwdPNQVSadsw6rg8Q7gs=";
    stripRoot = false;
  };
in {
  services = {
    postgresql = {
      enable = true;
      ensureDatabases = [config.services.gitea.user]; # "gitea" par défaut
      ensureUsers = [
        {
          name = config.services.gitea.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    gitea = {
      enable = true;
      database = {
        type = "postgres";
      };
      settings = {
        server = {
          HTTP_ADDR = "127.0.0.1";
          HTTP_PORT = 3002;
          ROOT_URL = "https://git.hadi.icu/";
          DOMAIN = "git.hadi.icu";
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
        repository = {
          DISABLE_STARS = true;
        };
        mailer = {ENABLED = false;};
        api = {ENABLE_SWAGGER = false;};
        other = {SHOW_FOOTER_VERSION = false;};
      };
    };

    cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."git.hadi.icu" = "http://localhost:3002";
  };

  systemd.services.gitea.preStart = lib.mkAfter ''
    mkdir -p ${config.services.gitea.stateDir}/custom/public/assets
    ln -sfn ${catppuccin-gitea} ${config.services.gitea.stateDir}/custom/public/assets/css
  '';
}
