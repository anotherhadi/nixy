# Hyprland user configuration (~/.config/hypr/hyprland.conf)
# Every desktop feature adds to hjem's `hyprland.settings` (merged like
# home-manager's wayland.windowManager.hyprland.settings), hosts set their monitors.
{
  aspects,
  config,
  ...
}: let
  inherit (config) theme;
  inherit (config.flake.lib) toHyprconf hyprconfType;
  c = theme.colors;
in {
  flake.modules.nixos.desktop = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({
        config,
        lib,
        pkgs,
        osConfig,
        ...
      }: {
        options.hyprland.settings = lib.mkOption {
          type = hyprconfType;
          default = {};
          description = "Hyprland configuration, see https://wiki.hypr.land";
        };

        config = {
          xdg.config.files."hypr/hyprland.conf".text = toHyprconf {attrs = config.hyprland.settings;};

          packages =
            (with pkgs.unstable; [
              qt5.qtwayland
              qt6.qtwayland
              hyprland-qtutils
            ])
            ++ (with pkgs; [
              libsForQt5.qt5ct
              qt6Packages.qt6ct
              xcb-util-cursor
              papirus-icon-theme
              material-icons
              material-design-icons
              material-symbols
              libxcb
              adw-gtk3
              hyprshot
              hyprpicker
              satty
              wf-recorder
              brightnessctl
              gnome-themes-extra
              dconf
              wayland-utils
              wayland-protocols
            ]);

          hyprland.settings = {
            monitor = [
              ",preferred,auto,1" # default
            ];

            exec-once = [
              "systemctl --user start app-com.mitchellh.ghostty.service"
            ];

            env = [
              "XDG_CURRENT_DESKTOP,Hyprland"
              "XDG_SESSION_TYPE,wayland"
              "XDG_SESSION_DESKTOP,Hyprland"
              "ANKI_WAYLAND,1"
              "DISABLE_QT5_COMPAT,0"
              "QT_AUTO_SCREEN_SCALE_FACTOR,1"
              "QT_QPA_PLATFORM,wayland;xcb"
              "QT_QPA_PLATFORMTHEME,gtk3"
              "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
              "ELECTRON_OZONE_PLATFORM_HINT,auto"
              "DIRENV_LOG_FORMAT,"
              "SDL_VIDEODRIVER,wayland"
              "CLUTTER_BACKEND,wayland"
            ];

            cursor = {
              no_hardware_cursors = true;
            };

            general = {
              resize_on_border = true;
              gaps_in = theme.gaps-in;
              gaps_out = theme.gaps-out;
              border_size = theme.border-size;
              layout = "master";
              "col.active_border" = "rgb(${c.base0D})";
              "col.inactive_border" = "rgba(${c.base00}EE)";
            };

            group = {
              "col.border_active" = "rgb(${c.base0D})";
              "col.border_inactive" = "rgb(${c.base03})";
              "col.border_locked_active" = "rgb(${c.base0C})";
              groupbar = {
                "col.active" = "rgb(${c.base0D})";
                "col.inactive" = "rgb(${c.base03})";
                text_color = "rgb(${c.base05})";
              };
            };

            decoration = {
              active_opacity = theme.active-opacity;
              inactive_opacity = theme.inactive-opacity;
              inherit (theme) rounding;
              shadow = {
                enabled = true;
                range = 20;
                render_power = 3;
                color = "rgba(${c.base00}99)";
              };
              blur = {
                enabled =
                  if theme.blur
                  then "true"
                  else "false";
                size = 18;
              };
            };

            master = {
              new_status = "slave";
              allow_small_split = true;
              mfact = 0.5;
            };

            gesture = "3, horizontal, workspace";

            layerrule = [
              "match:namespace launcher, animation popin 70%"
              "match:namespace swaync-control-center, animation slide right"
            ];

            windowrule = [
              "match:class .*, suppress_event maximize"
              "match:class helium, suppress_event fullscreen"
              "match:class helium, sync_fullscreen false"

              "match:class ^(steam_app_.*)$, suppress_event fullscreen"
              "match:class ^(steam_app_.*)$, sync_fullscreen false"

              "match:class proton-authenticator, float on"
              "match:class proton-authenticator, center on"
              "match:class proton-authenticator, size 500 400"

              "match:class protonvpn-app, float on"
              "match:class protonvpn-app, center on"
              "match:class protonvpn-app, size 500 400"

              "match:title run-bg, float on"
              "match:title run-bg, center on"
              "match:title run-bg, size 700 80"

              "match:workspace special:scratch, opacity 1 1"
              "match:workspace special:scratch, no_anim on"
            ];

            misc = {
              disable_hyprland_logo = true;
              disable_splash_rendering = true;
              disable_autoreload = true;
              focus_on_activate = true;
              background_color = "rgb(${c.base00})";
            };

            input = {
              kb_layout = osConfig.services.xserver.xkb.layout;

              kb_options = "caps:escape";
              follow_mouse = 1;
              sensitivity = 0.5;
              repeat_delay = 300;
              repeat_rate = 50;
              numlock_by_default = true;

              touchpad = {
                natural_scroll = true;
                clickfinger_behavior = true;
              };
            };

            ecosystem = {
              no_update_news = true;
            };
          };

          environment.sessionVariables = {
            XDG_ICON_DIR = "${pkgs.papirus-icon-theme}/share/icons/Papirus";
            QS_ICON_THEME = "Papirus";
            QT_STYLE_OVERRIDE = "Fusion";
          };
        };
      })
    ];
  };
}
