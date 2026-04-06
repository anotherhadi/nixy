{config, ...}: {
  services.default-creds = {
    enable = true;
    port = 8087;
  };

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."default-creds.${config.var.domain}" = "http://localhost:${toString config.services.default-creds.port}";
}
