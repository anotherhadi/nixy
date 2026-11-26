# Mosquitto is an MQTT broker, used by Frigate to publish events to Home Assistant
# Not exposed on the LAN: only localhost and the frigate container can reach it
{
  flake.modules.nixos.mosquitto = {config, ...}: {
    sops.secrets = {
      mqtt-frigate-password = {};
      mqtt-hass-password = {};
    };

    services.mosquitto = {
      enable = true;
      listeners = [
        {
          port = 1883;
          users = {
            frigate = {
              passwordFile = config.sops.secrets.mqtt-frigate-password.path;
              acl = ["readwrite frigate/#"];
            };
            hass = {
              passwordFile = config.sops.secrets.mqtt-hass-password.path;
              acl = ["readwrite #"];
            };
          };
        }
      ];
    };

    networking.firewall.interfaces."ve-frigate".allowedTCPPorts = [1883];
  };
}
