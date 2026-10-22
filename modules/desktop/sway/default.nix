# Sway user configuration (~/.config/sway/config), mirrors the Hyprland one.
# Features add raw lines to hjem's `sway.config`, hosts set their outputs.
# Reuses the Hyprland session tools: hypridle/hyprlock, swaync. The bar is swaybar
# (./bar.nix) and the wallpaper swaybg: waybar and hyprpaper crash under sway.
{config, ...}: let
  inherit (config) theme;
  c = theme.colors;
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      config,
      lib,
      pkgs,
      osConfig,
      ...
    }: {
      options.sway.config = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Sway configuration lines, see sway(5). `$mod` is defined.";
      };

      config = {
        xdg.config.files."sway/config".text = ''
          set $mod Mod4
          ${config.sway.config}
        '';

        # Compositor environment, sourced by uwsm (Hyprland's `env`)
        xdg.config.files."uwsm/env-sway".text = ''
          export WLR_NO_HARDWARE_CURSORS=1
          export ANKI_WAYLAND=1
          export DISABLE_QT5_COMPAT=0
          export QT_AUTO_SCREEN_SCALE_FACTOR=1
          export QT_QPA_PLATFORM="wayland;xcb"
          export QT_QPA_PLATFORMTHEME=gtk3
          export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
          export ELECTRON_OZONE_PLATFORM_HINT=auto
          export DIRENV_LOG_FORMAT=
          export SDL_VIDEODRIVER=wayland
          export CLUTTER_BACKEND=wayland
        '';

        packages = with pkgs; [sway-contrib.grimshot];

        sway.config = ''
          # Startup
          # exec lines run in parallel: units need finalize's WAYLAND_DISPLAY first
          exec uwsm finalize SWAYSOCK I3SOCK XCURSOR_SIZE XCURSOR_THEME && systemctl --user start app-com.mitchellh.ghostty.service hyprpolkitagent.service
          # Splits the focused window along its longest side (no master layout in sway)
          exec ${pkgs.autotiling-rs}/bin/autotiling-rs

          # Look
          default_border pixel ${toString theme.border-size}
          default_floating_border pixel ${toString theme.border-size}
          gaps inner ${toString theme.gaps-in}
          gaps outer ${toString theme.gaps-out}
          swaybg_command ${pkgs.swaybg}/bin/swaybg
          output * bg ${pkgs.fetchurl theme.wallpaper} fill

          # class                 border     background text       indicator  child_border
          client.focused          #${c.base0D} #${c.base0D} #${c.base00} #${c.base0D} #${c.base0D}
          client.focused_inactive #${c.base00} #${c.base00} #${c.base05} #${c.base00} #${c.base00}
          client.unfocused        #${c.base00} #${c.base00} #${c.base05} #${c.base00} #${c.base00}
          client.urgent           #${c.base08} #${c.base08} #${c.base00} #${c.base08} #${c.base08}

          # Behaviour
          default_orientation auto
          focus_follows_mouse yes
          focus_on_window_activation focus

          # Input
          input type:keyboard {
            xkb_layout ${osConfig.services.xserver.xkb.layout}
            xkb_options caps:escape
            repeat_delay 300
            repeat_rate 50
            xkb_numlock enabled
          }
          input type:pointer pointer_accel 0.5
          input type:touchpad {
            pointer_accel 0.5
            natural_scroll enabled
            click_method clickfinger
            tap enabled
          }

          # Window rules
          for_window [app_id="proton-authenticator"] floating enable, resize set 500 400, move position center
          for_window [app_id="protonvpn-app"] floating enable, resize set 500 400, move position center
          for_window [title="run-bg"] floating enable, resize set 700 80, move position center
        '';
      };
    })
  ];
}
