# Stirling-pdf is a high-performance PDF editor and viewer service.
{config, ...}: {
  services.stirling-pdf = {
    enable = true;
    environment."SERVER_PORT" = "8083";
  };

  services.cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress."pdf.hadi.diy" = "http://localhost:${toString config.services.stirling-pdf.environment.SERVER_PORT}";
}
