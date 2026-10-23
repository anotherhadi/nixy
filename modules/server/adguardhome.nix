# Adguard is a network-wide ad blocker
# When installed, open localhost:3000 to setup
{
  flake.modules.nixos.adguardhome = {
    config,
    lib,
    ...
  }: {
    services.adguardhome = {
      enable = true;
      port = 3000;
    };

    networking.firewall = {
      allowedTCPPorts = [53];
      allowedUDPPorts = [53];
      extraCommands = ''
        iptables -I INPUT 1 -s 10.233.0.0/16 -p tcp --dport 3000 -j ACCEPT
      '';
      extraStopCommands = ''
        iptables -D INPUT -s 10.233.0.0/16 -p tcp --dport 3000 -j ACCEPT 2>/dev/null || true
      '';
    };

    services.cloudflared.tunnels."${config.nixy.server.tunnelId}".ingress."adguard.${config.nixy.server.domain}" = "http://localhost:${toString config.services.adguardhome.port}";

    # The tunnel resolves through AdGuard: start it once DNS is up
    systemd.services."cloudflared-tunnel-${config.nixy.server.tunnelId}" = lib.mkIf config.services.cloudflared.enable {
      after = ["adguardhome.service"];
      requires = ["adguardhome.service"];
    };
  };
}
