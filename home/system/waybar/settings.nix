{
  config,
  pkgs,
  networkScript,
  bluetoothScript,
  ...
}: let
  gaps-out = config.theme.gaps-out;
  c = config.lib.stylix.colors;
in {
  programs.waybar.settings = [
    {
      layer = "top";
      position = "top";
      height = config.theme.bar-height;
      margin = "${toString gaps-out} ${toString gaps-out} 0";
      modules-center = ["custom/osd" "custom/osd-sep" "clock" "tray" "hyprland/workspaces" "custom/network" "custom/bluetooth" "battery"];

      # ── Modules ─────────────────────────────────────────────────────────

      "hyprland/workspaces" = {
        format = "{id}";
        all-outputs = true;
        move-to-monitor = true;
        ignore-workspaces = ["[5-9]" "[1-9][0-9]+"];
        on-scroll-down = "hyprctl dispatch workspace e+1";
        on-scroll-up = "hyprctl dispatch workspace e-1";
        persistent-workspaces."*" = [1 2 3 4];
        cursor = true;
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

      "custom/bluetooth" = {
        exec = "${bluetoothScript}";
        exec-if = "${pkgs.bluez}/bin/bluetoothctl list 2>/dev/null | grep -q Controller";
        return-type = "json";
        interval = 5;
        on-click-right = "blueman-manager &";
        on-click = "bluetooth-toggle";
      };

      "custom/osd" = {
        exec = "cat /tmp/waybar-osd";
        exec-if = "test -f /tmp/waybar-osd";
        signal = 8;
        interval = "once";
        format = "{}";
      };

      "custom/osd-sep" = {
        exec = "echo '|'";
        exec-if = "test -f /tmp/waybar-osd";
        signal = 8;
        interval = "once";
        format = "{}";
        tooltip = false;
      };

      pulseaudio = {
        format = "{icon}";
        format-bluetooth = "{icon}";
        tooltip-format = "{volume}%";
        format-muted = "<span size='12pt'>󰝟</span>";
        scroll-step = 2;
        on-click = "vol-mute";
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
