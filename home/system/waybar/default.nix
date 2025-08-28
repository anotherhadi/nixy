{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./swaync.nix
    ./swayosd.nix
  ];

  wayland.windowManager.hyprland.settings.exec-once = ["waybar" "${pkgs.networkmanagerapplet}/bin/nm-applet" "${pkgs.blueman}/bin/blueman-applet"];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      spacing = 5;
      margin-bottom = -11;

      modules-left = ["hyprland/workspaces" "hyprland/window"];
      modules-center = ["cava"];
      modules-right = [
        "group/extras"
        "pulseaudio"
        "battery"
        "clock"
        "custom/notification"
      ];

      battery = {
        states = {critical = 20;};
        format = "{icon}";
        format-icons = {
          default = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
        };
        format-full = "󱟢";
        on-click = "powermode-toggle";
        on-click-right = ''${pkgs.swayosd}/bin/swayosd-client --custom-message="Powermode is set to $(powerprofilesctl get)" --custom-icon="emblem-default"'';
      };

      "custom/vpn" = {
        interval = 3;
        format = "{}";
        exec = ''
          if ip add show | ${pkgs.ripgrep}/bin/rg -qF "proton"; then
            echo '{"text":"󰖂   VPN On","class":"vpn-on"}'
          else
            echo '{"text":"󰖂   VPN Off","class":"vpn-off"}'
          fi
        '';
        return-type = "json";
        max-length = "100";
        on-click = "protonvpn-app";
      };

      cava = {
        framerate = 240;
        bars = 20;
        bar_delimiter = 0;
        stereo = true;
        input_delay = 4;
        sleep_timer = 2;
        hide_on_silence = true;
        lower_cutoff_freq = 100;
        higher_cutoff_freq = 8000;
        format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
      };

      clock = {
        timezone = "Europe/Paris";
        tooltip-format = "<span>{calendar}</span>";
        calendar = {
          mode = "month";
          format = {
            today = "<span color='#e7bbe4'><b>{}</b></span>";
            days = "<span color='#cdd6f4'><b>{}</b></span>";
            weekdays = "<span color='#7cd37c'><b>{}</b></span>";
            months = "<b>{}</b>";
          };
        };
        interval = 60;
        max-length = 25;
        on-click = "brave --profile-directory=Default --app-id=ojibjkjikcpjonjjngfkegflhmffeemk"; # Proton Calendar
      };

      "custom/arrow-toggle" = {
        format = " {icon} ";
        format-icons = {default = "";};
        tooltip = false;
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t";
        escape = true;
      };

      "group/extras" = {
        orientation = "inherit";
        drawer = {
          transition-duration = 300;
          transitition-left-to-right = false;
        };
        modules = ["custom/arrow-toggle" "tray" "custom/vpn"];
      };

      "hyprland/window" = {
        format = "{}";
        rewrite = {"^(.*?)[[:space:]]*[-—|].*?$" = "$1";};
        icon = true;
        icon-size = 20;
        max-length = 30;
      };

      "hyprland/workspaces" = {
        format = "{icon}";
        format-active = " {icon} ";
        all-outputs = true;
      };

      network = {
        format = "{ifname}";
        format-wifi = "{icon} {essid}";
        format-ethernet = "󰈀 Ethernet";
        format-disconnected = " 󰤭 Disconnected ";
        tooltip-format = "{ipaddr}  {bandwidthUpBits}  {bandwidthDownBits}";
        format-linked = "󰈁 {ifname} (No IP)";
        format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        on-click = "kitty --class nmtui-float-term nmtui";
      };

      pulseaudio = {
        format = "{icon}";
        format-muted = "󰖁";
        format-icons = ["󰕿" "󰖀" "󰕾"];
        on-click = "sound-toggle";
        scroll-step = 1;
      };

      tray = {spacing = 10;};
    };

    style = ''
      * {
        font-family: ${config.stylix.fonts.serif.name}, sans-serif;
      }

      window#waybar {
          background-color: transparent;
      }

      #workspaces{
          background-color: transparent;
          margin-top: 10px;
          margin-bottom: 10px;
          margin-right: 10px;
          margin-left: 25px;
      }
      #workspaces button{
          background-color: #${config.lib.stylix.colors.base05};
          color: 	#${config.lib.stylix.colors.base00};
          box-shadow: rgba(0, 0, 0, 0.116) 2 2 5 2px;
          border-radius: 15px;
          margin-right: 10px;
          padding-top: 4px;
          padding-bottom: 2px;
          padding-right: 10px;
          font-weight: bolder;
      }

      .modules-left #workspaces button {
          border-bottom: 0px;
      }

      #workspaces button.active{
          padding-right: 20px;
          box-shadow: rgba(0, 0, 0, 0.288) 2 2 5 2px;
          text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
          padding-left: 20px;
          background: #${config.lib.stylix.colors.base0D};
          color: #${config.lib.stylix.colors.base05};
      }

      .modules-left #workspaces button.focused,
      .modules-left #workspaces button.active {
          border-bottom: 0px;
      }

      #window {
        color: #${config.theme.textColorOnWallpaper};
      }

      #clock,
      #battery,
      #network,
      #pulseaudio,
      #tray,
      #cava,
      #custom-notification,
      #custom-vpn,
      #mpd {
          padding: 0 10px;
          border-radius: 15px;
          background-color: #${config.lib.stylix.colors.base05};
          color: 	#${config.lib.stylix.colors.base00};
          box-shadow: rgba(0, 0, 0, 0.116) 2 2 5 2px;
          margin-top: 10px;
          margin-bottom: 10px;
          margin-right: 10px;
      }

      #cava{
          background: #${config.lib.stylix.colors.base0D};
          color: #${config.lib.stylix.colors.base05};
          text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
          font-weight: 900;
          padding-top: 0px;
          margin-left: 10px;
      }

      #pulseaudio,
      #pulseaudio.muted{
          color: #${config.lib.stylix.colors.base0D};
          font-size: 20px;
          font-weight:  bolder;
          padding-left: 14px;
          padding-right: 15px;
          border-radius: 15px;
      }

      #custom-notification {
          background: #${config.lib.stylix.colors.base0D};
          color: #${config.lib.stylix.colors.base05};
          font-size: 20px;
          font-weight: bolder;
          padding-left: 20px;
          padding-right: 24px;
      }

      #battery {
          color: #86a381;
          font-size: 17px;
          padding-left: 15px;
          padding-right: 15px;
          border-radius: 15px;
      }

      @keyframes blink {
          to {
              background-color: #f9e2af;
              color:#96804e;
          }
      }

      #custom-vpn.vpn-on {
        color: #2ecc71;
      }

      #custom-vpn.vpn-off {
        color: #e74c3c;
      }

      #battery.critical:not(.charging) {
          background-color:  #f38ba8;
          color:#bf5673;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #network{
          color:#000;
      }

      #network.disabled{
          background-color: #45475a;
      }

      #network.disconnected{
          background: rgb(243,139,168);
          color: #fff;
          font-weight: bolder;
      }

      #network.linked, #network.wifi{
          background-color: #a6e3a1 ;
      }

      #network.ethernet{
          background-color:#f9e2af ;
      }

      #tray {
          background-color: #1c1816;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #custom-arrow-toggle {
          font-size: 16px;
          color: #516079;
          opacity: 1;
          transition: opacity 0.2s ease-in-out;
      }

      #extras:hover #custom-arrow-toggle {
          opacity: 0;
      }

      #extras:hover {
          background-color: transparent;
      }
    '';
  };
}
