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
    # Allow containers to reach adguard UI (for glance dns-stats widget)
    extraCommands = ''
      iptables -I INPUT 1 -s 10.233.0.0/16 -p tcp --dport 3000 -j ACCEPT
    '';
    extraStopCommands = ''
      iptables -D INPUT -s 10.233.0.0/16 -p tcp --dport 3000 -j ACCEPT 2>/dev/null || true
    '';
  };

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."adguard.${config.var.domain}" = "http://localhost:${toString config.services.adguardhome.port}";
}
