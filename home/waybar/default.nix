{ config, lib, ... }: {
  imports = [ ../variables/theme ];
  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 0;
        "margin-top" = config.theme.gaps-out;
        "margin-left" = config.theme.gaps-out;
        "margin-right" = config.theme.gaps-out;
        height = 40;
        modules-left = [ "custom/logo" "hyprland/window" ];
        modules-center = [ "hyprland/workspaces" ];
        modules-right =
          [ "tray" "backlight" "pulseaudio" "battery" "clock" "custom/power" ];

        "wlr/taskbar" = {
          format = "{icon}";
          "on-click" = "activate";
          "on-click-right" = "fullscreen";

          "icon-size" = 25;
          "tooltip-format" = "{title}";
        };

        "hyprland/workspaces" = {
          "on-click" = "activate";
          format = "{icon}";
          "format-icons" = {
            "default" = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "active" = "󱓻";
            "urgent" = "󱓻";
          };
          "persistent_workspaces" = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
        };

        tray = { spacing = 16; };

        clock = {
          "tooltip-format" = "<tt>{calendar}</tt>";
          "format-alt" = "  {:%a, %d %b %Y}";
          format = "󰥔  {:%I:%M %p}";
        };

        pulseaudio = {
          format = "{icon}";
          "format-bluetooth" = "󰂰";
          nospacing = 1;
          "tooltip-format" = "Volume : {volume}%";
          "format-muted" = "󰝟";
          "format-icons" = {
            "headphone" = "";
            "default" = [ "󰖀" "󰕾" "" ];
          };
          "on-click" = "pamixer -t";
          "scroll-step" = 1;
        };

        "custom/logo" = {
          format = "  ";
          tooltip = false;
          "on-click" = "~/scripts/menu.sh";
        };

        battery = {
          format = "{capacity}% {icon}";
          "format-icons" = {
            "charging" = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
            "default" = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          };
          "format-full" = "󰁹 ";
          interval = 10;
          states = {
            warning = 20;
            critical = 10;
          };
          tooltip = false;
        };

        "custom/power" = {
          format = "󰤆";
          tooltip = false;
          "on-click" = "wlogout";
        };

        backlight = {
          device = "nvidia_0";
          format = "{icon}";
          "format-icons" = [ " " " " "" "" "" "" "" "" "" ];
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: "${config.theme.font}";
        color: #${config.theme.colors.fg};
      }

      window#waybar {
        background-color: #${config.theme.colors.bg};
        transition-property: background-color;
        transition-duration: 0.5s;
        border-radius: ${toString config.theme.rounding}px;
        font-size: 13px;
      }

      window#waybar.hidden {
        opacity: 0.5;
      }

      #workspaces {
        background-color: transparent;
      }

      #workspaces button {
        all: initial; /* Remove GTK theme values (waybar #1351) */
        min-width: 0; /* Fix weird spacing in materia (waybar #450) */
        box-shadow: inset 0 -3px transparent; /* Use box-shadow instead of border so the text isn't offset */
        padding: 6px 18px;
        margin: 6px 3px;
        border-radius: 4px;
        background-color: #${config.theme.colors.alt-bg};
        color: #${config.theme.colors.alt-fg};
      }

      #workspaces button.active {
        color: #${config.theme.colors.primary-fg};
        background-color: #${config.theme.colors.primary-bg};
      }

      #workspaces button:hover {
       box-shadow: inherit;
       text-shadow: inherit;
       opacity: 0.8;
      }

      #workspaces button.urgent {
        background-color: #${config.theme.colors.color1};
      }

      #memory,
      #custom-power,
      #battery,
      #backlight,
      #pulseaudio,
      #network,
      #clock,
      #tray,
      #backlight{
        border-radius: 9px;
        margin: 6px 3px;
        padding: 6px 12px;
        background-color: #${config.theme.colors.alt-bg};
        color: #${config.theme.colors.alt-fg};
      }

      #tray menu {
        background-color: #${config.theme.colors.alt-bg};
        color: #${config.theme.colors.alt-fg};
      }

      #custom-power {
        margin-right: 6px;
      }

      #custom-logo {
        padding-right: 7px;
        padding-left: 7px;
        margin-left: 5px;
        font-size: 15px;
        border-radius: 8px 0px 0px 8px;
        color: #${config.theme.colors.primary-bg};
      }

      @keyframes blink {
        to {
          background-color: #f38ba8;
          color: #181825;
        }
      }

      #battery.warning,
      #battery.critical,
      #battery.urgent {
        background-color: #ff0048;
        color: #181825;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #battery.charging {
        background-color: #1E1E2E;
        color: #FBFBFB;
        animation: none;
      }

      #custom-power {
        background-color: #9978F8;
        color: #0C0C0C;
        margin-right: 7px;
      }


      tooltip {
        border-radius: 8px;
        padding: 15px;
        background-color: #${config.theme.colors.alt-bg};
        color: #${config.theme.colors.alt-fg};
      }

      tooltip label {
        padding: 5px;
        background-color: #${config.theme.colors.alt-bg};
        color: #${config.theme.colors.alt-fg};
      }
    '';
  };
}
