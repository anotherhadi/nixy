{config, ...}: {
  services.default-creds = {
    enable = true;
    port = 8087;
  };

  services.cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress."default-creds.hadi.diy" = "http://localhost:${toString config.services.default-creds.port}";
}
