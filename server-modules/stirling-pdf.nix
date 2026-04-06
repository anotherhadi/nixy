# Stirling-pdf is a high-performance PDF editor and viewer service.
{config, ...}: {
  services.stirling-pdf = {
    enable = true;
    environment."SERVER_PORT" = "8083";
  };

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."pdf.${config.var.domain}" = "http://localhost:${toString config.services.stirling-pdf.environment.SERVER_PORT}";
}
