{config, networkScript, ...}: let
  gaps-out = config.theme.gaps-out;
  c = config.lib.stylix.colors;
in {
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      height = 25;
      margin = "${toString gaps-out} ${toString gaps-out} 0";
      modules-center = ["clock" "tray" "hyprland/workspaces" "custom/network" "bluetooth" "battery" "group/right-hidden"];

      "group/right-hidden" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = false;
          click-to-reveal = true;
        };
        modules = ["custom/arrow-right" "power-profiles-daemon" "mpris" "group/group-volume"];
      };

      "group/group-volume" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 600;
          transition-left-to-right = true;
          reveal-delay = 450;
        };
        modules = ["pulseaudio" "pulseaudio/slider"];
      };

      # ── Modules ─────────────────────────────────────────────────────────

      "hyprland/workspaces" = {
        format = "{id}";
        on-scroll-down = "hyprctl dispatch workspace e+1";
        on-scroll-up = "hyprctl dispatch workspace e-1";
        persistent-workspaces."*" = 4;
        cursor = true;
      };

      mpris = {
        format = "󰐊";
        format-paused = "󰏤";
        tooltip-format = "{title}";
        tooltip-format-paused = "{title}";
        on-click = "playerctl play-pause";
        on-scroll-up = "playerctl previous";
        on-scroll-down = "playerctl next";
      };

      battery = {
        bat = "BAT1";
        interval = 20;
        full-at = 100;
        tooltip = true;
        format-full = "";
        format = "{icon} ";
        format-charging = " {icon} ";
        format-icons = ["" "" "" "" ""];
        tooltip-format = "{capacity}%  ·  {time}";
        tooltip-format-full = "Full\n{capacity}%";
        tooltip-format-charging = "Charging\n{capacity}%  ·  {time}";
        states = {
          warning = 30;
          critical = 15;
        };
      };

      "power-profiles-daemon" = {
        format = "{icon}";
        tooltip-format = "Power profile: {profile}";
        format-icons = {
          performance = "";
          balanced = "";
          power-saver = "";
        };
      };

      bluetooth = {
        format = "{}";
        format-on = "󰂰";
        format-off = "󰂲";
        format-disabled = "";
        format-connected = "{device_alias}";
        format-connected-battery = "{device_alias}";
        tooltip-format = "Bluetooth {status}";
        tooltip-format-connected = "Bluetooth {status}\n{device_enumerate}";
        tooltip-format-enumerate-connected = "  {device_alias}";
        tooltip-format-enumerate-connected-battery = "  {device_alias}  {device_battery_percentage}%";
        on-click-right = "blueman-manager &";
      };

      pulseaudio = {
        format = "{icon}";
        format-bluetooth = "{icon}";
        tooltip-format = "{volume}%";
        format-muted = "<span size='12pt'>󰝟</span>";
        scroll-step = 2;
        on-click = "swayosd-client --output-volume mute-toggle";
        on-click-right = "pavucontrol -t 4 &";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
        };
      };

      "pulseaudio/slider" = {
        min = 0;
        max = 100;
        cursor = true;
      };

      "custom/network" = {
        exec = "${networkScript}";
        return-type = "json";
        interval = 10;
        on-click-right = "ghostty -e wifitui &";
      };

      tray = {
        icon-size = 13;
        spacing = 12;
        cursor = true;
      };

      clock = {
        timezone = config.var.timeZone;
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        format = "{:%H:%M}";
        format-alt = "{:%H:%M %d %B %Y}";
        calendar = {
          mode = "month";
          format = {
            months = "<span color='#${c.base04}'><b>{}</b></span>";
            weekdays = "<span color='#${c.base0A}'><b>{}</b></span>";
            days = "<span color='#${c.base05}'>{}</span>";
            today = "<span color='#${c.base0D}'><b><u>{}</u></b></span>";
          };
        };
      };

      "custom/arrow-left" = {
        format = " ";
        tooltip = false;
        cursor = true;
      };

      "custom/arrow-right" = {
        format = " ";
        tooltip = false;
        cursor = true;
      };
    }
  ];
}
