{ pkgs, config, ... }: {

  imports = [ ./hyprlock.nix ./hypridle.nix ./hyprpaper.nix ];

  home.packages = with pkgs; [
    hyprshot
    xdg-desktop-portal-hyprland
    wlr-randr
    wl-clipboard
    brightnessctl
    gnome.gnome-themes-extra
    wlsunset
    xwayland
    xdg-desktop-portal-gtk
    wlroots
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
        [ "${pkgs.hypridle}/bin/hypridle" "${pkgs.hyprpaper}/bin/hyprpaper" ];

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
        "GTK_THEME,Flat-Remix-GTK-Grey-Darkest:dark"
      ];

      general = {
        resize_on_border = true;
        gaps_in = 10;
        gaps_out = 20;
        border_size = 2;
        "col.active_border" = "rgba(${config.theme.colors.primary-bg}ff)";
        "col.inactive_border" = "rgba(${config.theme.colors.color0}96)";
        layout = "master";
      };

      decoration = {
        rounding = config.theme.rounding;
        drop_shadow = true;
        shadow_range = 15;
        shadow_render_power = 4;
        "col.shadow" = "rgba(${config.theme.colors.color0}96)";
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
      name = "Flat-Remix-GTK-Grey-Darkest";
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
