{
  pkgs,
  pkgs-stable,
  lib,
  config,
  ...
}: let
  colors = config.lib.stylix.colors;

  mkMenu = menu: let
    configFile = pkgs.writeText "config.yaml" (
      lib.generators.toYAML {} {
        anchor = "bottom-right";
        border = "#${colors.base0D}80";
        background = "#${colors.base01}EE";
        color = "#${colors.base05}";
        margin_right = 15;
        margin_bottom = 15;
        rows_per_column = 5;

        inherit menu;
      }
    );
  in
    pkgs.writeShellScriptBin "menu" ''
      exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
    '';
in {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    "$shiftMod" = "SUPER_SHIFT";

    bind =
      [
        # Applications
        (
          "$shiftMod, A, exec, "
          + lib.getExe (mkMenu [
            {
              key = "a";
              desc = "Proton Authenticator";
              cmd = "env WEBKIT_DISABLE_COMPOSITING_MODE=1 ${pkgs.proton-authenticator}/bin/proton-authenticator";
            }
            {
              key = "p";
              desc = "Proton Pass";
              cmd = "${pkgs.proton-pass}/bin/proton-pass";
            }
            {
              key = "v";
              desc = "Proton VPN";
              cmd = "${pkgs.proton-vpn}/bin/protonvpn-app";
            }
            {
              key = "c";
              desc = "Proton Calendar";
              cmd = "${config.programs.helium.package}/bin/helium 'https://calendar.proton.me/'";
            }
            {
              key = "m";
              desc = "Proton Mail";
              cmd = "${config.programs.helium.package}/bin/helium 'https://mail.proton.me/'";
            }
            {
              key = "o";
              desc = "Obsidian";
              cmd = "${pkgs-stable.obsidian}/bin/obsidian";
            }
            {
              key = "s";
              desc = "Signal";
              cmd = "${pkgs-stable.signal-desktop}/bin/signal-desktop";
            }
            {
              key = "t";
              desc = "TickTick";
              cmd = "${pkgs-stable.ticktick}/bin/ticktick";
            }
            {
              key = "b";
              desc = "Helium";
              cmd = "${config.programs.helium.package}/bin/helium";
            }
            {
              key = "i";
              desc = "Helium (Incognito)";
              cmd = "${config.programs.helium.package}/bin/helium --incognito";
            }
          ])
        )

        "$mod,B, exec, uwsm app -- ${config.programs.helium.package}/bin/helium" # Browser

        # Power
        (
          "$mod, X, exec, "
          + lib.getExe (mkMenu [
            {
              key = "l";
              desc = "Lock";
              cmd = "hyprlock";
            }
            {
              key = "s";
              desc = "Suspend";
              cmd = "systemctl suspend";
            }
            {
              key = "r";
              desc = "Reboot";
              cmd = "systemctl reboot";
            }
            {
              key = "p";
              desc = "Power Off";
              cmd = "systemctl poweroff";
            }
            {
              key = "n";
              desc = "Nightshift";
              cmd = "nightshift-toggle";
            }
          ])
        )

        # Quick launch
        "$mod,RETURN, exec, uwsm app -- ${pkgs.ghostty}/bin/ghostty" # Ghostty (terminal)
        "$mod,E, exec,  uwsm app -- ${pkgs-stable.thunar}/bin/thunar" # Thunar
        "$mod, SPACE, exec, tofi-drun" # Launcher
        "$mod, N, exec, swaync-client -t" # Notification center

        # Windows
        "$mod,Q, killactive," # Close window
        "$mod,F, fullscreen" # Toggle Fullscreen
        "$shiftMod,F, togglefloating," # Toggle Floating
        "$shiftMod, SPACE, exec, focus-toggle" # Toggle focus mode

        # Focus Windows
        "$mod,H, movefocus, l" # Move focus left
        "$mod,J, movefocus, d" # Move focus Down
        "$mod,K, movefocus, u" # Move focus Up
        "$mod,L, movefocus, r" # Move focus Right
        "$shiftMod,H, focusmonitor, -1" # Focus previous monitor
        "$shiftMod,J, layoutmsg, removemaster" # Remove from master
        "$shiftMod,K, layoutmsg, addmaster" # Add to master
        "$shiftMod,L, focusmonitor, 1" # Focus next monitor

        # Utilities
        "$shiftMod, S, exec, hyprshot -m region" # Capture region
        ", Print, exec, hyprshot -m region" # Capture region
        "$shiftMod+Alt, S, exec, hyprshot -m output" # Capture screen
      ]
      ++ (builtins.concatLists (
        builtins.genList (
          i: let
            ws = i + 1;
          in [
            "$mod,code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT,code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
        9
      ));

    bindm = [
      "$mod,mouse:272, movewindow" # Move Window (mouse)
      "$mod,R, resizewindow" # Resize Window (mouse)
    ];

    bindl = [
      # Brightness
      ", XF86MonBrightnessUp, exec, bright-up"
      ", XF86MonBrightnessDown, exec, bright-down"

      # Media
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioStop, exec, playerctl stop"

      # Sound
      ", XF86AudioMute, exec, vol-mute"
      ", XF86AudioRaiseVolume, exec, vol-up"
      ", XF86AudioLowerVolume, exec, vol-down"
      ", XF86AudioMicMute, exec, mic-mute"
    ];
  };
}
