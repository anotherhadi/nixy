# Frigate is an NVR with realtime object detection for IP cameras
{config, ...}: let
  inherit (config.flake.lib) mkContainer;
in {
  flake.modules.nixos.frigate = {
    config,
    lib,
    ...
  }: let
    domain = config.nixy.server.domain;

    # Tapo cameras (C210), name -> IP
    # Credentials come from the frigate-env sops secret
    cameras = {
      camera1 = "192.168.1.143";
      camera2 = "192.168.1.14";
    };

    # go2rtc is the only client of the cameras (Tapo cameras handle few RTSP connections),
    # Frigate and Home Assistant read the restream on rtsp://10.233.14.2:8554/<name>
    # `${VAR}` is go2rtc's env substitution, read from the frigate-env file
    go2rtcStreams =
      lib.concatMapAttrs (name: ip: let
        tapo = stream: "rtsp://\${FRIGATE_RTSP_USER}:\${FRIGATE_RTSP_PASSWORD}@${ip}:554/${stream}";
      in {
        # HD stream, for recording & live
        ${name} = tapo "stream1";
        # SD stream, for detection
        "${name}_sub" = tapo "stream2";
      })
      cameras;

    frigateCamera = name: ip: {
      ffmpeg.inputs = [
        {
          path = "rtsp://127.0.0.1:8554/${name}";
          input_args = "preset-rtsp-restream";
          roles = ["record"];
        }
        {
          path = "rtsp://127.0.0.1:8554/${name}_sub";
          input_args = "preset-rtsp-restream";
          roles = ["detect"];
        }
      ];
      live.streams = {
        "HD" = name;
        "SD" = "${name}_sub";
      };
      # Pan/tilt controls
      onvif = {
        host = ip;
        port = 2020;
        user = "{FRIGATE_RTSP_USER}";
        password = "{FRIGATE_RTSP_PASSWORD}";
      };
    };
  in {
    imports = [
      (mkContainer config {
        name = "frigate";
        hostIp = "10.233.14.1";
        containerIp = "10.233.14.2";
        # Reach the cameras on the local network
        lan = ["192.168.1.0/24"];
        bindMounts = {
          # Database, recordings, clips & exports
          "/var/lib/frigate" = {
            hostPath = "/mnt/data/frigate";
            isReadOnly = false;
          };
          "/run/secrets/frigate-env" = {
            hostPath = config.sops.templates."frigate-env".path;
            isReadOnly = true;
          };
          # AMD GPU for VA-API hardware decoding
          "/dev/dri" = {
            hostPath = "/dev/dri";
            isReadOnly = false;
          };
        };
        nixosConfig = {...}: {
          hardware.graphics.enable = true;

          services.frigate = {
            enable = true;
            hostname = "frigate.${domain}";
            vaapiDriver = "radeonsi";
            # The config check runs at build time, without access to the secret
            preCheckConfig = ''
              export FRIGATE_RTSP_USER=dummy FRIGATE_RTSP_PASSWORD=dummy FRIGATE_MQTT_PASSWORD=dummy
            '';
            settings = {
              ffmpeg.hwaccel_args = "preset-vaapi";
              # Events for Home Assistant, through mosquitto on the host
              mqtt = {
                enabled = true;
                host = "10.233.14.1";
                port = 1883;
                user = "frigate";
                password = "{FRIGATE_MQTT_PASSWORD}";
              };
              record = {
                enabled = true;
                retain = {
                  days = 7;
                  mode = "motion";
                };
              };
              cameras = lib.mapAttrs frigateCamera cameras;
            };
          };

          services.go2rtc = {
            enable = true;
            settings = {
              # Only reached through Frigate's nginx
              api.listen = "127.0.0.1:1984";
              rtsp.listen = ":8554";
              # WebRTC disabled, live uses MSE over websocket (through Caddy) instead
              webrtc.listen = "";
              streams = go2rtcStreams;
            };
          };

          systemd.services.frigate.serviceConfig.EnvironmentFile = "/run/secrets/frigate-env";
          systemd.services.go2rtc.serviceConfig.EnvironmentFile = "/run/secrets/frigate-env";

          # 80: Frigate UI, 8554: RTSP restream for Home Assistant
          networking.firewall.allowedTCPPorts = [80 8554];
          system.stateVersion = "24.05";
        };
      })
    ];

    sops.secrets.frigate-env = {};
    # Camera credentials + MQTT password (shared with mosquitto)
    sops.templates."frigate-env" = {
      owner = "root";
      mode = "0400";
      content = ''
        ${config.sops.placeholder.frigate-env}
        FRIGATE_MQTT_PASSWORD=${config.sops.placeholder.mqtt-frigate-password}
      '';
      restartUnits = ["container@frigate.service"];
    };

    containers.frigate.allowedDevices = [
      {
        node = "/dev/dri/renderD128";
        modifier = "rw";
      }
    ];

    systemd.tmpfiles.rules = ["d /mnt/data/frigate 0750 root root -"];

    nixy.server.proxies.frigate = "http://10.233.14.2:80";
  };
}
