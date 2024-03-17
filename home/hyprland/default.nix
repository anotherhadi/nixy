{ pkgs, config, ... }: {

  imports = [ ./hyprlock.nix ./hypridle.nix ./hyprpaper.nix ];

  home.packages = with pkgs; [
    hyprshot
    hyprpicker
    xdg-desktop-portal-hyprland
    wlr-randr
    wl-clipboard
    brightnessctl
    gnome.gnome-themes-extra
    wlsunset
    xwayland
    xdg-desktop-portal-gtk
    wlroots
    qt5ct
    libva
    dconf
    wayland-utils
    wayland-protocols
    meson
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";
      "$menu" = "menu";
      "$powermenu" = "${pkgs.wlogout}/bin/wlogout";

      exec-once =
        [ "${pkgs.hypridle}/bin/hypridle" "${pkgs.hyprpaper}/bin/hyprpaper" "${pkgs.bitwarden}/bin/bitwarden" ];

      monitor = [
        "eDP-2,highres,0x0,1"
        "desc:AOC U34G2G1 0x00000E06,highrr,2560x0,1"
        ",prefered,auto,1"
      ];

      bind = [
        "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, Q, killactive,"
        "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
        "$mod, T, togglefloating,"
        "$mod, F, fullscreen"
        "$mod, B, exec, ${pkgs.qutebrowser}/bin/qutebrowser"
        "$mod, C, exec, ${pkgs.kitty}/bin/kitty --class peaclock peaclock"
        "$mod, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
        "$mod, SPACE, exec, $menu"
        "$mod, X, exec, $powermenu"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, PRINT, exec, ${pkgs.hyprshot}/bin/hyprshot -m window -o ~/Pictures/screenshots"
        ", PRINT, exec, ${pkgs.hyprshot}/bin/hyprshot -m output -o ~/Pictures/screenshots"
        "$shiftMod, PRINT, exec, ${pkgs.hyprshot}/bin/hyprshot -m region -o ~/Pictures/screenshots"
        "$mod, F2, exec, night-shift-off"
        "$mod, F3, exec, night-shift-on"
      ] ++ (builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]) 9));

      bindm = [ "$mod, mouse:272, movewindow" "$mod, R, resizewindow" ];

      bindl = [
        ",XF86AudioMute, exec, sound-toggle"
        ",switch:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, sound-up"
        ", XF86AudioLowerVolume, exec, sound-down"
        ", XF86MonBrightnessUp, exec, brightness-up"
        ", XF86MonBrightnessDown, exec, brightness-down"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM=wayland,xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GTK_THEME,Flat-Remix-GTK-White-Darkest-Solid:dark"
      ];

      general = {
        resize_on_border = true;
        gaps_in = config.theme.gaps-in;
        gaps_out = config.theme.gaps-out;
        border_size = config.theme.border-size;
        "col.active_border" = "rgba(${config.theme.colors.primary-bg}ff)";
        "col.inactive_border" = "rgba(00000055)";
        border_part_of_window = true;
        layout = "master";
      };

      decoration = {
        rounding = config.theme.rounding;
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgba(00000055)";
        blur = { enabled = false; };
      };

      master = {
        new_is_master = true;
        new_on_top = true;
      };

      gestures = { workspace_swipe = true; };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
      };

      input = {
        kb_layout = "fr"; # CHANGEME

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

      windowrulev2 = [
        "float, class:peaclock"
        "move 2% 78%, class:peaclock"
        "size 30% 20%, class:peaclock"
        "float, title:Bluetooth Devices"
        "move 20% 20%, title:Bluetooth Devices"
        "size 60% 60%, title:Bluetooth Devices"
      ];

      animations = {
        enabled = true;
        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
        ];

        animation = [
          "windowsIn, 1, 3, easeOutCubic, popin 30% # window open"
          "windowsOut, 1, 3, fluent_decel, popin 70% # window close."
          "fadeIn, 1, 3, easeOutCubic  # fade in (open) -> layers and windows"
          "fadeOut, 1, 2, easeOutCubic # fade out (close) -> layers and windows"
          "fadeSwitch, 0, 1, easeOutCirc # fade on changing activewindow and its opacity"
          "fadeShadow, 1, 10, easeOutCirc # fade on changing activewindow for shadows"
          "fadeDim, 1, 4, fluent_decel # the easing of the dimming of inactive windows"
          "border, 1, 2.7, easeOutCirc # for animating the border's color switch speed"
          "borderangle, 1, 30, fluent_decel, once # for animating the border's gradient angle - styles: once (default), loop"
          "workspaces, 1, 4, easeOutCubic, fade # styles: slide, slidevert, fade, slidefade, slidefadevert"
        ];
      };

    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "gtk2";
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-White-Darkest-Solid";
    };

    iconTheme = {
      package = pkgs.flat-remix-icon-theme;
      name = "Flat-Remix-Grey-Darkest";
    };

    font = {
      name = config.theme.font;
      size = 11;
    };
  };

}
