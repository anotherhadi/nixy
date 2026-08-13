{
  config,
  pkgs,
  networkScript,
  bluetoothScript,
  caffeineToggleScript,
  osdStatusScript,
  nightshiftToggleScript,
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
      modules-center = ["custom/osd" "custom/osd-sep" "clock" "tray" "hyprland/workspaces" "custom/network" "custom/bluetooth" "battery" "group/drawer"];

      # ── Modules ─────────────────────────────────────────────────────────

      "hyprland/workspaces" = {
        format = "{id}";
        all-outputs = true;
        move-to-monitor = true;
        ignore-workspaces = ["[5-9]" "[1-9][0-9]+"];
        on-scroll-down = "${pkgs.hyprland}/bin/hyprctl dispatch workspace e+1";
        on-scroll-up = "${pkgs.hyprland}/bin/hyprctl dispatch workspace e-1";
        persistent-workspaces."*" = [1 2 3 4];
        cursor = true;
      };

      battery = {
        interval = 20;
        full-at = 100;
        tooltip = true;
        format = "{icon} ";
        format-charging = " {icon} ";
        format-icons = ["" "" "" "" ""];
        tooltip-format = "{capacity}%  ·  {time}";
        tooltip-format-full = "Full\n{capacity}%";
        tooltip-format-charging = "Charging\n{capacity}%  ·  {time}";
        on-click = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs.nur.repos.anotherhadi.settuings}/bin/settuings --page power";
        states = {
          warning = 30;
          critical = 15;
        };
      };

      "custom/caffeine" = {
        exec = "${pkgs.coreutils}/bin/printf '󰅶'";
        exec-if = "! systemctl --user is-active --quiet hypridle";
        format = "{}";
        interval = 5;
        on-click = "${caffeineToggleScript}/bin/caffeine-toggle";
        tooltip = false;
      };

      "custom/nightshift" = {
        exec = "${pkgs.coreutils}/bin/printf '󰖔'";
        exec-if = "${pkgs.procps}/bin/pgrep -x hyprsunset";
        format = "{}";
        interval = 5;
        on-click = "${nightshiftToggleScript}/bin/nightshift-toggle";
        tooltip = false;
      };

      "custom/bluetooth" = {
        exec = "${bluetoothScript}";
        exec-if = "${pkgs.bluez}/bin/bluetoothctl list 2>/dev/null | grep -q Controller";
        return-type = "json";
        interval = 5;
        on-click = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs.nur.repos.anotherhadi.settuings}/bin/settuings --page bluetooth";
      };

      "custom/osd" = {
        exec = "cat /tmp/waybar-osd";
        exec-if = "${osdStatusScript}/bin/waybar-osd-status";
        signal = 8;
        interval = 1;
        format = "{}";
      };

      "custom/osd-sep" = {
        exec = "echo '|'";
        exec-if = "${osdStatusScript}/bin/waybar-osd-status";
        signal = 8;
        interval = 1;
        format = "{}";
        tooltip = false;
      };

      pulseaudio = {
        format = "{icon}";
        format-bluetooth = "{icon}";
        tooltip-format = "{volume}%";
        format-muted = "<span size='12pt'>󰝟</span>";
        scroll-step = 2;
        on-click = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs.nur.repos.anotherhadi.settuings}/bin/settuings --page audio";
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
        on-click = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs.nur.repos.anotherhadi.settuings}/bin/settuings --page network";
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

      "group/drawer" = {
        orientation = "horizontal";
        drawer = {
          transition-duration = 300;
          children-class = "drawer-child";
          transition-left-to-right = false;
        };
        modules = ["custom/arrow-right" "pulseaudio" "custom/nightshift" "custom/caffeine"];
      };

      "custom/arrow-right" = {
        format = " ";
        tooltip = false;
        cursor = true;
      };
    }
  ];
}
