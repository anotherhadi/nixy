{config, ...}: {
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    configWritable = true;
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
      scene = "!include scenes.yaml";
      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
    };
  };

  systemd.services.home-assistant.preStart = ''
    for f in scenes.yaml automations.yaml scripts.yaml; do
      path="${config.services.home-assistant.configDir}/$f"
      [ -f "$path" ] || echo "[]" > "$path"
    done
  '';

  services.matter-server = {
    enable = true;
    extraArgs.primary-interface = config.var.networkInterface;
  };

  networking.firewall.allowedUDPPorts = [5353];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."hass.${config.var.domain}" = "http://localhost:${toString config.services.home-assistant.config.http.server_port}";
}
