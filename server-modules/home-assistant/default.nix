{
  config,
  lib,
  pkgs,
  ...
}: let
  nixyTheme = import ./theme.nix {inherit config pkgs;};
  plugins = import ./plugins.nix {inherit pkgs;};

  signalRecipients = [
    "h"
    "d"
  ];
in {
  sops.secrets =
    {
      signal_sender_number.owner = "hass";
      alarm_code.owner = "hass";
    }
    // lib.genAttrs signalRecipients (_: {owner = "hass";});

  sops.templates."home-assistant-secrets.yaml" = {
    path = "${config.services.home-assistant.configDir}/secrets.yaml";
    owner = "hass";
    restartUnits = ["home-assistant.service"];
    content =
      "signal_sender: \"${config.sops.placeholder.signal_sender_number}\"\n"
      + "alarm_code: \"${config.sops.placeholder.alarm_code}\"\n"
      + lib.concatMapStrings (n: "${n}: \"${config.sops.placeholder.${n}}\"\n") signalRecipients;
  };

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
      "sonos"
      "apple_tv"
      "signal_messenger"
      "manual"
      "meteo_france"
      "remote_calendar"
    ];
    customComponents = plugins.customComponents;
    customLovelaceModules = plugins.customLovelaceModules;
    config = {
      default_config = {};
      http = {
        trusted_proxies = ["127.0.0.1" "::1"];
        use_x_forwarded_for = true;
      };
      scene = "!include scenes.yaml";
      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
      frontend.themes = nixyTheme;
      alarm_control_panel = [
        {
          platform = "manual";
          name = "Home";
          code = "!secret alarm_code";
          code_arm_required = false;
          armed_home = {
            arming_time = 0;
            delay_time = 0;
            trigger_time = 120;
          };
          armed_away = {
            arming_time = 30;
            delay_time = 30;
            trigger_time = 120;
          };
        }
      ];
      notify =
        (map (n: {
            name = "signal_${n}";
            platform = "signal_messenger";
            url = config.services.signal-cli-rest-api.url;
            number = "!secret signal_sender";
            recipients = ["!secret ${n}"];
          })
          signalRecipients)
        ++ [
          {
            name = "signal_all";
            platform = "signal_messenger";
            url = config.services.signal-cli-rest-api.url;
            number = "!secret signal_sender";
            recipients = map (n: "!secret ${n}") signalRecipients;
          }
        ];
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
