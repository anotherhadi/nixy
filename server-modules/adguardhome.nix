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

  services.cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress."adguard.hadi.icu" = "http://localhost:${toString config.services.adguardhome.port}";
}
