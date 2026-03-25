# Cyberchef is a web app for analyzing and decoding data.
{pkgs, ...}: {
  services = {
    nginx.virtualHosts."cyberchef.local" = {
      root = "${pkgs.cyberchef}/share/cyberchef";
      listen = [
        {
          addr = "127.0.0.1";
          port = 8754;
        }
      ];
    };
    cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."cyberchef.hadi.icu" = "http://localhost:8754";
  };
}
