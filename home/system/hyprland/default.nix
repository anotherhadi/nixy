# Hyprland is a dynamic tiling Wayland compositor that is highly customizable and performant.
{
  pkgs-unstable,
  pkgs,
  config,
  lib,
  ...
}: let
  border-size = config.theme.border-size;
  gaps-in = config.theme.gaps-in;
  gaps-out = config.theme.gaps-out;
  active-opacity = config.theme.active-opacity;
  inactive-opacity = config.theme.inactive-opacity;
  rounding = config.theme.rounding;
  blur = config.theme.blur;
  keyboardLayout = config.var.keyboardLayout;
  background = "rgba(" + config.lib.stylix.colors.base00 + "EE)";
in {
  imports = [
    ./animations.nix
    ./bindings.nix
    ./polkitagent.nix
    ./hyprpaper.nix
  ];

  home.packages =
    (with pkgs-unstable; [
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
      imv
      wf-recorder
      brightnessctl
      gnome-themes-extra
      dconf
      wayland-utils
      wayland-protocols
    ]);

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
    xwayland.enable = true;
    systemd.enable = false;
    package = null;
    portalPackage = null;

    settings = {
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
        gaps_in = gaps-in;
        gaps_out = gaps-out;
        border_size = border-size;
        layout = "master";
        "col.inactive_border" = lib.mkForce background;
      };

      decoration = {
        active_opacity = active-opacity;
        inactive_opacity = inactive-opacity;
        rounding = rounding;
        shadow = {
          enabled = true;
          range = 20;
          render_power = 3;
        };
        blur = {
          enabled =
            if blur
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

        "match:class proton-authenticator, float on"
        "match:class proton-authenticator, center on"
        "match:class proton-authenticator, size 500 400"

        "match:class protonvpn-app, float on"
        "match:class protonvpn-app, center on"
        "match:class protonvpn-app, size 500 400"

        "match:title run-bg, float on"
        "match:title run-bg, center on"
        "match:title run-bg, size 700 80"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        focus_on_activate = true;
      };

      input = {
        kb_layout = keyboardLayout;

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
  };

  qt.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

  home.sessionVariables = {
    XDG_ICON_DIR = "${pkgs.papirus-icon-theme}/share/icons/Papirus";
    QS_ICON_THEME = "Papirus";
    QT_STYLE_OVERRIDE = lib.mkForce "Fusion";
  };
}
