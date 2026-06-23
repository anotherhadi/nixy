{ osConfig ? {}, lib, ... }: let
  hasBluetooth = osConfig.hardware.bluetooth.enable or false;
in {
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      height = 25;
      margin = "5 0";

      modules-left   = [ "group/left-hidden-top" "group/left" ];
      modules-center = [ "clock" ];
      modules-right  = [ "group/right" "group/right-hidden-top" ];

      # ── Groups ────────────────────────────────────────────────────────

      "group/left" = {
        orientation = "horizontal";
        modules = [ "hyprland/workspaces" "mpris" ];
      };

      # power-profiles-daemon visible + hidden drawer (arrow → battery cpu load)
      "group/left-hidden-top" = {
        orientation = "horizontal";
        modules = [ "power-profiles-daemon" "group/left-hidden" ];
      };

      "group/left-hidden" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = false;
          click-to-reveal = true;
        };
        modules = [ "custom/arrow-right" "battery" "cpu" "load" ];
      };

      # bluetooth volume network tray (visible)
      "group/right" = {
        orientation = "horizontal";
        modules = lib.optional hasBluetooth "bluetooth" ++ [ "group/group-volume" "network" "tray" ];
      };

      # hidden drawer (arrow ← memory temp) + ctlcenter visible
      "group/right-hidden-top" = {
        orientation = "horizontal";
        modules = [ "group/right-hidden" "custom/ctlcenter" ];
      };

      "group/right-hidden" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 500;
          transition-left-to-right = true;
          click-to-reveal = true;
        };
        modules = [ "custom/arrow-left" "memory" "temperature" ];
      };

      "group/group-volume" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 600;
          transition-left-to-right = true;
          reveal-delay = 450;
        };
        modules = [ "pulseaudio" "pulseaudio/slider" ];
      };

      # ── Modules ─────────────────────────────────────────────────────────

      "hyprland/workspaces" = {
        format = "{icon}";
        on-scroll-down = "hyprctl dispatch workspace e+1";
        on-scroll-up = "hyprctl dispatch workspace e-1";
        persistent-workspaces."*" = 5;
        cursor = true;
        format-icons = {
          active = "󰮯";
          persistent = "";
          empty = "";
        };
      };

      mpris = {
        format = "{artist} - {title}";
        tooltip-format = "{album}";
        format-paused = " {artist} - {title}";
        on-click = "playerctl play-pause";
        on-scroll-up = "playerctl previous";
        on-scroll-down = "playerctl next";
        max-length = 45;
      };

      battery = {
        interval = 20;
        full-at = 100;
        tooltip = true;
        format-full = "";
        format = "{icon}  {capacity}%";
        format-time = "{H}:{M:02}";
        format-charging = "  {capacity}% ({time})";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂂" "󰁹" ];
        states = {
          warning = 30;
          critical = 15;
        };
      };

      cpu = {
        interval = 30;
        format = "  {usage}%";
        cursor = true;
        states = {
          warning = 80;
          critical = 90;
        };
      };

      load = {
        interval = 30;
        format = "  {load1}%";
        cursor = true;
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

      memory = {
        interval = 10;
        format = "  {used:0.1f}G/{total:0.1f}G";
        states = {
          warning = 80;
          critical = 90;
        };
      };

      temperature = {
        interval = 10;
        format = "{icon}  {temperatureC}°";
        critical-threshold = 90;
        format-icons = [ "" "" "" "" "" ];
      };

      bluetooth = {
        format = "{}";
        format-on = "󰂰";
        format-off = "󰂲";
        format-disabled = "";
        format-connected = "{device_alias}";
        format-connected-battery = "{device_alias}";
        tooltip-format = "{device_enumerate}";
        tooltip-format-enumerate-connected = "{device_alias}";
        tooltip-format-enumerate-connected-battery = "{device_alias}   {device_battery_percentage}%";
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
            "<span size='12pt'>󰕿</span>"
            "<span size='12pt'>󰖀</span>"
            "<span size='12pt'>󰕾</span>"
          ];
        };
      };

      "pulseaudio/slider" = {
        min = 0;
        max = 100;
        cursor = true;
      };

      network = {
        interval = 10;
        format-disabled = "";
        format-disconnected = "";
        format-wifi = "";
        format-ethernet = "";
        tooltip-format = "{essid}

Frequency: {frequency}GHz
Strength: {signalStrength}%

{bandwidthUpBytes}   {bandwidthDownBytes}";
        on-click-right = "ghostty -e nmtui &";
      };

      tray = {
        icon-size = 13;
        spacing = 12;
        cursor = true;
      };

      clock = {
        timezone = "Europe/Paris";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        format = "{:%H:%M}";
        format-alt = "{:%H:%M %d %B %Y}";
        calendar = {
          mode = "year";
          weeks-pos = "right";
          mode-mon-col = 3;
          format = {
            months   = "<span color='#acb0d0'><b>{}</b></span>";
            weeks    = "<span color='#7aa2f7'><b>W{}</b></span>";
            weekdays = "<span color='#e0af68'><b>{}</b></span>";
            days     = "<span color='#acb0d0'><b>{}</b></span>";
            today    = "<span color='#41a6b5'><b><u>{}</u></b></span>";
          };
        };
      };

      "custom/ctlcenter" = {
        format = "";
        tooltip = false;
        on-click = "swaync-client -t &";
      };

      "custom/arrow-left" = {
        format = "";
        tooltip = false;
        cursor = true;
      };

      "custom/arrow-right" = {
        format = "";
        tooltip = false;
        cursor = true;
      };
    }
  ];
}
