{pkgs, ...}: {
  services.swaync = {
    enable = true;
    settings = {
      control-center-layer = "top";
      control-center-width = 400;
      control-center-height = 400;
      control-center-margin-top = 10;
      control-center-margin-bottom = 250;
      control-center-margin-right = 10;

      notification-window-width = 380;
      notification-icon-size = 48;
      notification-body-image-height = 80;
      notification-body-image-width = 160;
      notification-2fa-action = true;
      notification-grouping = false;

      image-visibility = "when-available";
      transition-time = 100;

      widgets = ["title" "buttons-grid" "dnd" "inhibitors" "mpris" "notifications"];

      widget-config = {
        inhibitors = {
          text = "Inhibitors";
          button-text = "Clear All";
          clear-all-button = true;
        };
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {text = "Do Not Disturb";};
        mpris = {
          image-size = 64;
          blur = true;
        };
        buttons-grid = {
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
              label = "󰌾";
              command = "lock";
            }
            {
              label = "󰍃";
              command = "${pkgs.hyprland}/bin/hyprctl dispatch exit";
            }
            {
              label = "󰕾";
              command = "${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
            }
            {
              label = "󰍬";
              command = "${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";
            }
            {
              label = "󰂯";
              command = "${pkgs.blueman}/bin/blueman-manager";
            }
            {
              label = "󰹑";
              command = "screenshot region";
            }
            {
              label = "";
              command = "${pkgs.kooha}/bin/kooha";
            }
            {
              label = "";
              command = "caffeine";
            }
            {
              label = "󰋱";
              command = "hyprfocus-toggle";
            }
          ];
        };
      };
    };
    style = ''
      .notification,
      .notification.low,
      .notification.normal,
      .notification.critical,
      .notification-default-action,
      .notification-default-action:hover,
      .notification-default-action:active,
      .notification-row:focus,
      .notification-group:focus,
      .notification-group.collapsed .notification-row .notification,
      .control-center .notification-row .notification-background,
      .control-center .notification-row .notification-background:hover,
      .control-center .notification-row .notification-background:active {
        background: transparent;
        border: none;
        outline: none;
        box-shadow: none;
        margin: 0;
        padding: 0;
      }

      .control-center {
        background: @base00;
        border: 1px solid @base0D;
        color: @base05;
        padding: 5px;
        border-radius: 15px;
      }

      .widget-body, .widget-mpris, .widget-dnd, .widget-inhibitors {
        margin: 4px 5px;
      }

      .notification-content {
        border-radius: 12px;
        padding: 10px;
        margin: 8px;
      }

      .notification-title {
        font-weight: bold;
        color: @base05;
      }

      .close-button {
        margin: 6px;
        padding: 3px;
        border-radius: 100px;
        background-color: transparent;
        border: 1px solid transparent;
      }

      .close-button:hover {
        background-color: @base0C;
      }

      .close-button:active {
        background-color: @base0C;
        color: @base00;
      }
    '';
  };
}
