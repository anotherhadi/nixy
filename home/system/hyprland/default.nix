{ pkgs, config, inputs, ... }: {

  imports =
    [ ./hyprlock/macos.nix ./hypridle.nix ./hyprpaper.nix ./hyprcursor.nix ];

  home.packages = with pkgs; [
    hyprshot
    hyprpicker
    swappy
    imv
    wf-recorder
    xdg-desktop-portal-hyprland
    wlr-randr
    wl-clipboard
    brightnessctl
    gnome-themes-extra
    wlsunset
    xwayland
    xdg-desktop-portal-gtk
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
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
    # plugins = [ inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo ]; # TODO: Fix, stack overflow

    settings = {
      "$mod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";

      exec-once = [
        "startup"
        "${pkgs.hypridle}/bin/hypridle"
        "${pkgs.hyprpaper}/bin/hyprpaper"
        "${pkgs.bitwarden}/bin/bitwarden"
      ];

      monitor = [ "eDP-2,highres,0x0,1" ",prefered,auto,1" ];

      bind = [
        "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty" # Kitty
        "$mod, E, exec, ${pkgs.xfce.thunar}/bin/thunar" # Thunar
        "$mod, B, exec, ${pkgs.qutebrowser}/bin/qutebrowser" # Qutebrowser
        "$mod, K, exec, ${pkgs.bitwarden}/bin/bitwarden" # Bitwarden
        "$mod, C, exec, ${pkgs.kitty}/bin/kitty --class peaclock peaclock" # Peaclock
        "$mod, L, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock
        "$mod, X, exec, powermenu" # Powermenu
        "$mod, SPACE, exec, menu" # Launcher

        "$mod, Q, killactive," # Close window
        "$mod, T, togglefloating," # Toggle Floating
        "$mod, F, fullscreen" # Toggle Fullscreen
        "$mod, left, movefocus, l" # Move focus left
        "$mod, right, movefocus, r" # Move focus Right
        "$mod, up, movefocus, u" # Move focus Up
        "$mod, down, movefocus, d" # Move focus Down

        "$mod, PRINT, exec, screenshot window" # Screenshot window
        ", PRINT, exec, screenshot monitor" # Screenshot monitor
        "$shiftMod, PRINT, exec, screenshot region" # Screenshot region
        "ALT, PRINT, exec, screenshot region swappy" # Screenshot region then edit

        "$mod, F2, exec, night-shift-off" # Turn off night shift
        "$mod, F3, exec, night-shift-on" # Turn on night shift

        "$mod, F5, exec, ${pkgs.kitty}/bin/kitty --class floating zsh -c sound-output" # Choose sound output
      ] ++ (builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
        in [
          "$mod, code:1${toString i}, workspace, ${toString ws}"
          "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
        ]) 9));

      bindm = [
        "$mod, mouse:272, movewindow" # Move Window (mouse)
        "$mod, R, resizewindow" # Resize Window (mouse)
      ];

      bindl = [
        ",XF86AudioMute, exec, sound-toggle" # Toggle Mute
        ",switch:Lid Switch, exec, ${pkgs.hyprlock}/bin/hyprlock" # Lock when closing Lid
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, sound-up" # Sound Up
        ", XF86AudioLowerVolume, exec, sound-down" # Sound Down
        ", XF86MonBrightnessUp, exec, brightness-up" # Brightness Up
        ", XF86MonBrightnessDown, exec, brightness-down" # Brightness Down
      ];

      env = [
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "ANKI_WAYLAND,1"
        "DISABLE_QT5_COMPAT,0"
        "NIXOS_OZONE_WL,1"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_QPA_PLATFORM=wayland,xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "GTK_THEME,FlatColor:dark"
        "GTK2_RC_FILES,/home/hadi/.local/share/themes/FlatColor/gtk-2.0/gtkrc"
      ];

      cursor = {
        no_hardware_cursors = true;
        default_monitor = "eDP-2";
      };

      general = {
        resize_on_border = true;
        gaps_in = config.var.theme.gaps-in;
        gaps_out = config.var.theme.gaps-out;
        border_size = config.var.theme.border-size;
        "col.active_border" = "rgba(${config.var.theme.colors.accent}ff)";
        "col.inactive_border" = "rgba(00000055)";
        border_part_of_window = true;
        layout = "master";
      };

      decoration = {
        rounding = config.var.theme.rounding;
        drop_shadow = true;
        shadow_range = 20;
        shadow_render_power = 3;
        "col.shadow" = "rgba(00000055)";
        blur = { enabled = false; };
      };

      master = {
        new_status = true;
        allow_small_split = true;
        mfact = 0.5;
      };

      gestures = { workspace_swipe = true; };

      misc = {
        vfr = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        disable_autoreload = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
      };

      render = { explicit_sync = "0"; };

      opengl = { nvidia_anti_flicker = false; };

      input = {
        kb_layout = config.var.keyboardLayout;

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

      windowrule = [ "animation popin,^(wlogout)$" ];

      windowrulev2 = [
        "float, class:peaclock"
        "move 2% 78%, class:peaclock"
        "size 30% 20%, class:peaclock"

        "float, class:floating"
        "size 40% 40%, class:floating"
        "move 30% 30%, class:floating"

        "float, title:Bluetooth Devices"
        "move 20% 20%, title:Bluetooth Devices"
        "size 60% 60%, title:Bluetooth Devices"
      ];

      animations = let
        animationSpeed = config.var.theme.animation-speed;

        animationDuration = if animationSpeed == "slow" then
          "4"
        else if animationSpeed == "medium" then
          "2.5"
        else
          "1.5";
        borderDuration = if animationSpeed == "slow" then
          "10"
        else if animationSpeed == "medium" then
          "6"
        else
          "3";
      in {
        enabled = true;
        bezier = [
          "linear, 0, 0, 1, 1"
          "md3_standard, 0.2, 0, 0, 1"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.1"
          "crazyshot, 0.1, 1.5, 0.76, 0.92"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "menu_decel, 0.1, 1, 0, 1"
          "menu_accel, 0.38, 0.04, 1, 0.07"
          "easeInOutCirc, 0.85, 0, 0.15, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "softAcDecel, 0.26, 0.26, 0.15, 1"
          "md2, 0.4, 0, 0.2, 1"
        ];

        animation = [
          "windows, 1, ${animationDuration}, md3_decel, popin 60%"
          "windowsIn, 1, ${animationDuration}, md3_decel, popin 60%"
          "windowsOut, 1, ${animationDuration}, md3_accel, popin 60%"
          "border, 1, ${borderDuration}, default"
          "fade, 1, ${animationDuration}, md3_decel"
          "layersIn, 1, ${animationDuration}, menu_decel, slide"
          "layersOut, 1, ${animationDuration}, menu_accel"
          "fadeLayersIn, 1, ${animationDuration}, menu_decel"
          "fadeLayersOut, 1, ${animationDuration}, menu_accel"
          "workspaces, 1, ${animationDuration}, menu_decel, slide"
          "specialWorkspace, 1, ${animationDuration}, md3_decel, slidevert"
        ];
      };

    };
  };
}
