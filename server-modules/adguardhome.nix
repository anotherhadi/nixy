# Adguard is a network-wide ad blocker
# When installed, open localhost:3000 to setup
{config, ...}: {
  services.adguardhome = {
    enable = true;
    port = 3000;
  };

  networking.firewall = {
    allowedTCPPorts = [53];
    allowedUDPPorts = [53];
  };

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."adguard.${config.var.domain}" = "http://localhost:${toString config.services.adguardhome.port}";
}
