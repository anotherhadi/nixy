{config, ...}: {
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      "default_config"
      "met"
      "esphome"
      "hue"
      "matter"
      "thread"
    ];
    config = {
      default_config = {};
      http = {
        trusted_proxies = ["127.0.0.1" "::1"];
        use_x_forwarded_for = true;
      };
    };
  };

  services.matter-server.enable = true;

  networking.firewall.allowedUDPPorts = [5353];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."hass.${config.var.domain}" = "http://localhost:${toString config.services.home-assistant.config.http.server_port}";
}
