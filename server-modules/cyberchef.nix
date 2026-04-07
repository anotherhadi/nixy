# Cyberchef is a web app for analyzing and decoding data.
{
  config,
  pkgs,
  ...
}: {
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
    cloudflared.tunnels."${config.var.tunnelId}".ingress."cyberchef.${config.var.domain}" = "http://localhost:8754";
  };
}
