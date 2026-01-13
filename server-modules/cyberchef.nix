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
    cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress."cyberchef.hadi.diy" = "http://localhost:8754";
  };
}
