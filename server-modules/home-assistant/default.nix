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

  motionRooms = [
    "toilet"
    "entry"
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
      "spotify"
      "apple_tv"
      "signal_messenger"
      "manual"
      "meteo_france"
      "remote_calendar"
      "systemmonitor"
      "uptime_kuma"
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
      frontend = {
        themes = nixyTheme;
        # Load card-mod early so it can style every card
        extra_module_url = ["/local/nixos-lovelace-modules/card-mod.js"];
      };
      # Timestamp of the last motion detection (trigger-based, survives restarts)
      template =
        map (room: {
          trigger = [
            {
              trigger = "state";
              entity_id = "binary_sensor.${room}_motion";
              to = "on";
            }
          ];
          sensor = [
            {
              name = "${room} last motion";
              unique_id = "${room}_last_motion";
              device_class = "timestamp";
              icon = "mdi:motion-sensor";
              state = "{{ now().isoformat() }}";
            }
          ];
        })
        motionRooms
        ++ [
          # Uptime Kuma monitors that are not up (down, pending or maintenance)
          {
            sensor = [
              {
                name = "Websites not up";
                unique_id = "websites_not_up";
                icon = "mdi:web-off";
                state = ''
                  {{ integration_entities('uptime_kuma')
                     | select('match', 'sensor\.')
                     | select('is_state', ['down', 'pending', 'maintenance'])
                     | list | count }}
                '';
                attributes.sites = ''
                  {{ integration_entities('uptime_kuma')
                     | select('match', 'sensor\.')
                     | select('is_state', ['down', 'pending', 'maintenance'])
                     | map('device_attr', 'name')
                     | list }}
                '';
              }
            ];
          }
          # Battery sensors below 15%
          {
            sensor = [
              {
                name = "Batteries to replace";
                unique_id = "batteries_to_replace";
                icon = "mdi:battery-alert-variant-outline";
                state = ''
                  {{ states.sensor
                     | selectattr('attributes.device_class', 'defined')
                     | selectattr('attributes.device_class', 'eq', 'battery')
                     | map(attribute='state')
                     | select('is_number') | map('float')
                     | select('lt', 15)
                     | list | count }}
                '';
                attributes.devices = ''
                  {% set ns = namespace(low=[]) %}
                  {% for s in states.sensor
                       | selectattr('attributes.device_class', 'defined')
                       | selectattr('attributes.device_class', 'eq', 'battery')
                       if is_number(s.state) and s.state | float < 15 %}
                    {% set ns.low = ns.low + [s.name ~ ' (' ~ s.state | int ~ '%)'] %}
                  {% endfor %}
                  {{ ns.low }}
                '';
              }
            ];
          }
        ];
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
  # Sonos event subscriptions (callbacks from speakers to HA)
  networking.firewall.allowedTCPPorts = [1400];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress = {
    "hass.${config.var.domain}" = "http://localhost:${toString config.services.home-assistant.config.http.server_port}";
  };
}
