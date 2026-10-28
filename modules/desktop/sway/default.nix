# Sway user configuration
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

        # Compositor environment, sourced by uwsm
        xdg.config.files."uwsm/env-sway".text = ''
          export WLR_NO_HARDWARE_CURSORS=1
          export NIXOS_OZONE_WL=1
          export QT_AUTO_SCREEN_SCALE_FACTOR=1
          export QT_QPA_PLATFORM="wayland;xcb"
          export QT_QPA_PLATFORMTHEME=gtk3
          export QT_STYLE_OVERRIDE=Fusion
          export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
          export SDL_VIDEODRIVER=wayland
        '';

        sway.config = ''
          # Startup
          exec uwsm finalize SWAYSOCK I3SOCK XCURSOR_SIZE XCURSOR_THEME

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
          focus_follows_mouse always
          mouse_warping container
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
        '';
      };
    })
  ];
}
