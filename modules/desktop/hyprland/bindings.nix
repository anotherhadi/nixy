{config, ...}: let
  c = config.theme.colors;
  border-size = config.theme.border-size;
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      lib,
      pkgs,
      scripts,
      ...
    }: let
      mkMenu = menu: let
        configFile = pkgs.writeText "config.yaml" (
          lib.generators.toYAML {} {
            anchor = "top";
            border = "#${c.base0D}EE";
            border_width = border-size;
            background = "#${c.base01}FF";
            color = "#${c.base05}";
            margin_top = 0;
            rows_per_column = 5;

            inherit menu;
          }
        );
      in
        pkgs.writeShellScriptBin "menu" ''
          # Toggle: if wlr-which-key is already open, closing it is all this run should do.
          if ${pkgs.procps}/bin/pkill -x wlr-which-key; then
            exit 0
          fi
          exec ${lib.getExe pkgs.wlr-which-key} ${configFile}
        '';
    in {
      # Shared with sway (modules/desktop/sway/bindings.nix)
      scripts.power-menu = pkgs.writeShellScriptBin "power-menu" ("exec "
        + lib.getExe (mkMenu [
          {
            key = "l";
            desc = "Lock";
            cmd = "${pkgs.hyprlock}/bin/hyprlock";
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
        ]));

      scripts.tofi-drun-toggle = pkgs.writeShellScriptBin "tofi-drun-toggle" ''
        # tofi-drun is a distinct process name from the plain "tofi" binary
        # used by the emoji/icon/clipboard pickers, so this can't close those.
        if ${pkgs.procps}/bin/pkill -x tofi-drun; then
          exit 0
        fi
        exec ${pkgs.tofi}/bin/tofi-drun
      '';

      hyprland.settings = {
        "$mod" = "SUPER";
        "$shiftMod" = "SUPER_SHIFT";

        bind =
          [
            "$mod, X, exec, ${scripts.power-menu}/bin/power-menu" # Power menu

            # Quick launch
            "$mod,RETURN, exec, ${pkgs.ghostty}/bin/ghostty +new-window" # Ghostty (terminal, via daemon D-Bus)
            "$mod,E, exec, ${pkgs.ghostty}/bin/ghostty +new-window -e elio" # Elio
            "$mod, SPACE, exec, ${scripts.tofi-drun-toggle}/bin/tofi-drun-toggle" # Launcher (toggle)
            "$mod, N, exec, ${pkgs.swaynotificationcenter}/bin/swaync-client -t" # Notification center

            # Windows
            "$mod,Q, killactive," # Close window
            "$mod,F, fullscreen" # Toggle Fullscreen
            "$shiftMod,F, togglefloating," # Toggle Floating
            "$shiftMod, SPACE, exec, ${scripts.focus-toggle}/bin/focus-toggle" # Toggle focus mode

            # Focus Windows
            "$mod,H, movefocus, l" # Move focus left
            "$mod,J, movefocus, d" # Move focus Down
            "$mod,K, movefocus, u" # Move focus Up
            "$mod,L, movefocus, r" # Move focus Right
            "$shiftMod,H, focusmonitor, -1" # Focus previous monitor
            "$shiftMod,J, layoutmsg, removemaster" # Remove from master
            "$shiftMod,K, layoutmsg, addmaster" # Add to master
            "$shiftMod,L, focusmonitor, 1" # Focus next monitor

            # Special workspaces
            "$mod, S, togglespecialworkspace, scratch" # Toggle scratch workspace
            "$shiftMod, S, movetoworkspace, special:scratch" # Move to scratch workspace

            # Utilities
            ", Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m region" # Capture region
            "$shiftMod, Print, exec, ${pkgs.hyprshot}/bin/hyprshot -m output" # Capture screen
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
          ", XF86MonBrightnessUp, exec, ${scripts.bright-up}/bin/bright-up"
          ", XF86MonBrightnessDown, exec, ${scripts.bright-down}/bin/bright-down"

          # Media
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
          ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
          ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
          ", XF86AudioStop, exec, ${pkgs.playerctl}/bin/playerctl stop"

          # Sound
          ", XF86AudioMute, exec, ${scripts.vol-mute}/bin/vol-mute"
          ", XF86AudioRaiseVolume, exec, ${scripts.vol-up}/bin/vol-up"
          ", XF86AudioLowerVolume, exec, ${scripts.vol-down}/bin/vol-down"
          ", XF86AudioMicMute, exec, ${scripts.mic-mute}/bin/mic-mute"
        ];
      };
    })
  ];
}
