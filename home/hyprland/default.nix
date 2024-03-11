{ pkgs, ... }: {

  home.packages = with pkgs; [
    xdg-desktop-portal-hyprland
    wlr-randr
    swww
    wl-clipboard
    brightnessctl
    gnome.gnome-themes-extra
    adwaita-qt
    adwaita-qt6
    gnome.adwaita-icon-theme
    wlsunset
    xwayland
    xdg-desktop-portal-gtk
    wlroots
    wayland-utils
    wayland-protocols
    meson
    xfce.thunar
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
      "$mod" = "SUPER";
      "$menu" = "~/scripts/menu.sh";
      "$powermenu" = "${pkgs.wlogout}/bin/wlogout";

      exec-once = [
        "swww init"
        "swww img /home/hadi/nextcloud/wallpaper/Dim.png"
      ];

      monitor = [
        "eDP-2,highres,0x0,1"
        "desc:AOC U34G2G1 0x00000E06,highrr,2560x0,1"
        ",prefered,auto,1"
      ];

      bind = [
        "$mod, RETURN, exec, kitty"
        "$mod, Q, killactive,"
        "$mod, E, exec, thunar"
        "$mod, T, togglefloating,"
        "$mod, F, fullscreen"
        "$mod, B, exec, qutebrowser"
        "$mod, C, exec, kitty --class floating peaclock"
        "$mod, L, exec, hyprlock"
        "$mod, SPACE, exec, $menu"
        "$mod, X, exec, $powermenu"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
      ] ++ (builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]) 9));

      bindm = [ "$mod, mouse:272, movewindow" "$mod, R, resizewindow" ];

      bindl = [
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle"
        ",switch:Lid Switch, exec, hyprlock"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 10%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "SWWW_TRANSITION,wipe"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM=wayland,xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "T_QPA_PLATFORMTHEME,qt5ct"
        "WLR_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"
        "GTK_THEME,Adwaita:dark"
        "GTK2_RC_FILES,/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc"
        "QT_STYLE_OVERRIDE,Adwaita-Dark"
      ];

      input = {
        kb_layout = "fr";

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

    };
  };
}
