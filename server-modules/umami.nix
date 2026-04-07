{config, ...}: {
  sops.secrets = {
    umami-secret = {
      mode = "0600";
    };
  };
  services.umami = {
    enable = true;
    settings = {
      PORT = 8097;
      APP_SECRET_FILE = config.sops.secrets.umami-secret.path;
      DISABLE_TELEMETRY = true;
      DISABLE_BOT_CHECK = true;
    };
  };
  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."umami.${config.var.domain}" = "http://localhost:${toString config.services.umami.settings.PORT}";
  systemd.services.default-creds.environment = {
    PUBLIC_UMAMI_URL = "https://umami.${config.var.domain}";
    # FIXME:
    PUBLIC_UMAMI_WEBSITE_ID = "7197484c-01ad-488e-9caa-5ab7b7595f08";
    UMAMI_URL = "http://localhost:8097";
    UMAMI_WEBSITE_ID = "7197484c-01ad-488e-9caa-5ab7b7595f08";
  };
}
