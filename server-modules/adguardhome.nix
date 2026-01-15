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

  services.cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress."adguard.hadi.diy" = "http://localhost:${toString config.services.adguardhome.port}";
}
