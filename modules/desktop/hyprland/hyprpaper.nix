# Hyprpaper sets the wallpaper (config.theme.wallpaper)
{config, ...}: let
  inherit (config) theme;
in {
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      xdg.config.files."hypr/hyprpaper.conf".text = ''
        wallpaper {
          monitor=
          path=${pkgs.fetchurl theme.wallpaper}
        }
        ipc=on
        splash=false
      '';

      systemd.services.hyprpaper = {
        description = "hyprpaper";
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        # Aborts under sway, which draws the wallpaper itself (modules/desktop/sway)
        unitConfig.ConditionEnvironment = ["WAYLAND_DISPLAY" "!SWAYSOCK"];
        serviceConfig = {
          ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
          Restart = "always";
          RestartSec = 10;
        };
      };

      hyprland.settings.exec-once = [
        "systemctl --user enable --now hyprpaper.service"
      ];
    })
  ];
}
