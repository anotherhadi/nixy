{ pkgs, ... }: {

  imports = [ ./style.nix ];

  home.packages = with pkgs; [ libnotify ];

  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";

      control-center-margin-top = 15;
      control-center-margin-bottom = 15;
      control-center-margin-right = 15;
      control-center-margin-left = 15;

      notification-icon-size = 32;
      notification-body-image-height = 50;
      notification-body-image-width = 50;

      timeout-low = 5;
      timeout = 10;
      timeout-critical = 0;

      fit-to-screen = true;
      control-center-width = 500;
      notification-window-width = 400;

      keyboard-shortcuts = true;
      image-visibility = "when-available";

      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      script-fail-notify = true;

      widgets = [
        "menubar"
        "title"
        "buttons-grid"
        "mpris"
        "volume"
        "backlight"
        "dnd"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notification Center";
          clear-all-button = true;
          button-text = "󰆴 Clear All";
        };
        dnd = { text = "Do Not Disturb"; };
        mpris = {
          image-size = 96;
          image-radius = 7;
        };
        volume = { label = "󰕾"; };
        backlight = {
          label = "󰃟";
          subsystem = "backlight";
          device = "nvidia_0";
        };
        menubar = {
          "menu#power-buttons" = {
            label = "󰐥";
            position = "right";
            actions = [
              {
                label = "󰐥";
                command = "systemctl poweroff";
              }
              {
                label = "󰜉";
                command = "systemctl reboot";
              }
              {
                label = "󰒲";
                command = "systemctl suspend";
              }
              {
                "label" = "󰌾";
                "command" = "${pkgs.hyprlock}/bin/hyprlock";
              }
              {
                "label" = "󰍃";
                "command" = "${pkgs.hyprland}/bin/hyprctl dispatch exit";
              }
            ];
          };
        };
        "buttons-grid" = {
          "actions" = [
            {
              "label" = "󰕾";
              "command" =
                "${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
            }
            {
              "label" = "󰍬";
              "command" =
                "${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            }
            {
              "label" = "󰂯";
              "command" = "${pkgs.blueman}/bin/blueman-manager";
            }
            {
              "label" = "󰹑";
              "command" =
                "${pkgs.grimblast}/bin/grimblast --notify --freeze --wait 1 copysave area ~/Pictures/$(date +%Y-%m-%dT%H%M%S).png";
            }
            {
              "label" = "";
              "command" = "${pkgs.kooha}/bin/kooha";
            }
          ];
        };
      };
    };

  };
}
