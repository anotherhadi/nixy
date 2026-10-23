# SwayNotificationCenter: notifications and control center
{config, ...}: let
  inherit (config) theme;
  c = theme.colors;
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      scripts,
      ...
    }: {
      packages = [pkgs.swaynotificationcenter];

      xdg.config.files."swaync/config.json" = {
        generator = (pkgs.formats.json {}).generate "swaync-config.json";
        value = {
          "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
          positionX = "right";
          positionY = "top";
          layer = "overlay";
          "control-center-layer" = "overlay";
          cssPriority = "user";
          "control-center-width" = 450;
          "control-center-margin-top" = theme.gaps-out * 2;
          "control-center-margin-bottom" = theme.gaps-out * 2;
          "control-center-margin-right" = 0;
          "fit-to-screen" = true;
          "notification-window-width" = 400;
          "notification-icon-size" = 40;
          "notification-body-image-height" = 500;
          "notification-body-image-width" = 500;
          "notification-inline-replies" = true;
          "notification-2fa-action" = false;
          timeout = 3;
          "timeout-low" = 2;
          "timeout-critical" = 6;
          "keyboard-shortcuts" = true;
          "image-visibility" = "when-available";
          "transition-time" = 200;
          "hide-on-clear" = false;
          "hide-on-action" = false;
          "script-fail-notify" = true;
          widgets = ["mpris" "volume" "backlight" "dnd" "buttons-grid" "notifications"];
          "widget-config" = {
            dnd.text = "Do not disturb";
            volume = {
              label = "󰕾";
              "show-per-app" = false;
            };
            backlight = {
              label = "󰃠";
              "min" = 0;
            };
            mpris = {
              "image-size" = 100;
              "image-radius" = 10;
              autohide = false;
              blacklist = ["org.mpris.MediaPlayer2.playerctld"];
            };
            "buttons-grid" = {
              actions = [
                {
                  label = "󰖔";
                  type = "toggle";
                  command = "${scripts.nightshift-toggle}/bin/nightshift-toggle";
                  "update-command" = "${pkgs.procps}/bin/pgrep -x wlsunset > /dev/null && echo true || echo false";
                }
                {
                  label = "󰈈";
                  type = "toggle";
                  command = "${scripts.focus-toggle}/bin/focus-toggle";
                  "update-command" = "test -f \"$XDG_RUNTIME_DIR/focus-mode\" && echo true || echo false";
                }
                {
                  label = "󰍭";
                  type = "toggle";
                  command = "${scripts.mic-mute}/bin/mic-mute";
                  "update-command" = "${scripts.mic-status}/bin/mic-status";
                }
                {
                  label = "󰌾";
                  command = "${pkgs.swaynotificationcenter}/bin/swaync-client -cp ; ${scripts.lock}/bin/lock";
                }
                {
                  label = "󰐥";
                  command = "${pkgs.swaynotificationcenter}/bin/swaync-client -cp ; systemctl poweroff";
                }
              ];
            };
          };
        };
      };

      xdg.config.files."swaync/style.css".text = ''
        @import url("file://${pkgs.swaynotificationcenter}/etc/xdg/swaync/style.css");

        :root {
          --cc-bg: #${c.base00};
          --noti-bg: ${lib.concatMapStringsSep ", " toString theme.rgb.base01};
          --noti-bg-darker: #${c.base00};
          --noti-border-color: #${c.base02};
          --text-color: #${c.base05};
          --bg-selected: #${c.base0D};
        }
      '';

      systemd.services.swaync = {
        description = "Swaync notification daemon";
        documentation = ["https://github.com/ErikReider/SwayNotificationCenter"];
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        unitConfig.ConditionEnvironment = "WAYLAND_DISPLAY";
        serviceConfig = {
          Type = "dbus";
          BusName = "org.freedesktop.Notifications";
          ExecStart = "${pkgs.swaynotificationcenter}/bin/swaync";
          Restart = "on-failure";
          Environment = ["GSK_RENDERER=ngl"];
        };
      };
    })
  ];
}
