# Stirling-pdf is a high-performance PDF editor and viewer service.
{config, ...}: {
  services.stirling-pdf = {
    enable = true;
    environment."SERVER_PORT" = "8083";
  };

  services.cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."pdf.hadi.icu" = "http://localhost:${toString config.services.stirling-pdf.environment.SERVER_PORT}";
}
