{config, ...}: {
  services.default-creds = {
    enable = true;
    port = 8087;
  };

  services.cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."default-creds.hadi.icu" = "http://localhost:${toString config.services.default-creds.port}";
}
