{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}: let
  inherit (import ./mk-container.nix {inherit lib config;}) mkContainer;
  domain = config.var.domain;
  catppuccin-gitea = pkgs-unstable.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.2/catppuccin-gitea.tar.gz";
    sha256 = "sha256-rZHLORwLUfIFcB6K9yhrzr+UwdPNQVSadsw6rg8Q7gs=";
    stripRoot = false;
  };

  giteaUrl = "http://10.233.11.2:3002";
  githubUsername = "anotherhadi";

  giteaGithubMirror = pkgs.writeShellApplication {
    name = "gitea-github-mirror";
    runtimeInputs = [pkgs.curl pkgs.jq];
    text = ''
      github_token="$(cat "$GITHUB_TOKEN_FILE")"
      gitea_token="$(cat "$GITEA_TOKEN_FILE")"

      tmp_github="$(mktemp)"
      tmp_gitea="$(mktemp)"
      trap 'rm -f "$tmp_github" "$tmp_gitea"' EXIT

      page=1
      while :; do
        resp="$(curl -sf -H "Authorization: Bearer $github_token" \
          "https://api.github.com/user/repos?affiliation=owner&per_page=100&page=$page")"
        echo "$resp" >> "$tmp_github"
        count="$(echo "$resp" | jq 'length')"
        [ "$count" -lt 100 ] && break
        page=$((page + 1))
      done

      page=1
      while :; do
        resp="$(curl -sf -H "Authorization: token $gitea_token" \
          "$GITEA_URL/api/v1/users/$GITEA_OWNER/repos?limit=50&page=$page")"
        echo "$resp" >> "$tmp_gitea"
        count="$(echo "$resp" | jq 'length')"
        [ "$count" -lt 50 ] && break
        page=$((page + 1))
      done

      existing="$(jq -s '[.[][].name]' "$tmp_gitea")"
      github_repos="$(jq -s 'add | map(select(.archived | not)) | map({name, private, clone_url, description: (.description // "")})' "$tmp_github")"

      echo "$github_repos" | jq -c '.[]' | while IFS= read -r repo; do
        name="$(echo "$repo" | jq -r '.name')"
        if echo "$existing" | jq -e --arg n "$name" 'index($n)' > /dev/null; then
          continue
        fi
        echo "Mirroring new repo: $name"
        body="$(echo "$repo" | jq \
          --arg owner "$GITEA_OWNER" \
          --arg token "$github_token" \
          '{clone_addr: .clone_url, service: "github", repo_name: .name, repo_owner: $owner, mirror: true, private: .private, auth_token: $token, description: .description, mirror_interval: "8h0m0s"}')"
        curl -sf -X POST -H "Authorization: token $gitea_token" -H "Content-Type: application/json" \
          "$GITEA_URL/api/v1/repos/migrate" -d "$body" > /dev/null \
          || echo "Failed to mirror $name" >&2
      done
    '';
  };
in {
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
      nixosConfig = {lib, ...}: {
        users.users.gitea.uid = lib.mkForce 978;
        users.groups.gitea.gid = lib.mkForce 968;

        services.postgresql = {
          enable = true;
          ensureDatabases = ["gitea"];
          ensureUsers = [
            {
              name = "gitea";
              ensureDBOwnership = true;
            }
          ];
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

        networking.firewall.allowedTCPPorts = [3002];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."git.${domain}" = giteaUrl;

  sops.secrets = {
    github-mirror-token = {};
    gitea-mirror-token = {};
  };

  systemd.services.gitea-github-mirror = {
    description = "Mirror all GitHub repos of ${githubUsername} into Gitea";
    after = ["network-online.target" "container@gitea.service"];
    wants = ["network-online.target"];
    environment = {
      GITHUB_TOKEN_FILE = config.sops.secrets.github-mirror-token.path;
      GITEA_TOKEN_FILE = config.sops.secrets.gitea-mirror-token.path;
      GITEA_URL = giteaUrl;
      GITEA_OWNER = githubUsername;
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${giteaGithubMirror}/bin/gitea-github-mirror";
    };
  };

  systemd.timers.gitea-github-mirror = {
    description = "Periodically mirror all GitHub repos into Gitea";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "30m";
      Persistent = true;
    };
  };
}
