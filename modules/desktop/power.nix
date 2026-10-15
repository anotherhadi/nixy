# Power profiles (power-profiles-daemon), battery state and notifications
{
  flake.modules.nixos.desktop = {lib, ...}: {
    config = lib.mkMerge [
      {
        environment.persistence."/persist".directories = [
          "/var/lib/upower" # battery calibration state
          "/var/lib/systemd/backlight" # remembers screen brightness
        ];

        services = {
          power-profiles-daemon.enable = true;
          upower = {
            enable = true;
            percentageLow = 10;
            percentageCritical = 5;
            percentageAction = 3;
          };
        };
      }

      {
        hjem.extraModules = [
          ({
            pkgs,
            scripts,
            ...
          }: {
            scripts.power-cycle = pkgs.writeShellScriptBin "power-cycle" ''
              ppd=${pkgs.power-profiles-daemon}/bin/powerprofilesctl
              cur=$("$ppd" get)
              case "$cur" in
                power-saver) next=balanced;    icon="󰾅" ;;
                balanced)    next=performance; icon="󰓅" ;;
                performance) next=power-saver; icon="󰌪" ;;
                *)           next=balanced;    icon="󰾅" ;;
              esac
              "$ppd" set "$next"
              OSD_TEXT="$icon  ''${next^}"
              ${scripts.waybar-osd}/bin/waybar-osd "$OSD_TEXT"
            '';

            packages = [
              pkgs.poweralertd
              scripts.power-cycle
              (pkgs.makeDesktopItem {
                name = "power-cycle";
                desktopName = "Power Profile";
                exec = "${scripts.power-cycle}/bin/power-cycle";
                icon = "power-profile-balanced-symbolic";
                comment = "Cycle power-saver / balanced / performance";
                categories = ["System"];
                terminal = false;
                keywords = ["power" "profile" "performance" "battery"];
              })
            ];

            # Event-driven low-battery/critical/full notifications via UPower dbus signals
            # (thresholds above, services.upower.percentage*).
            systemd.services.poweralertd = {
              description = "UPower-powered battery notifications";
              wantedBy = ["graphical-session.target"];
              serviceConfig = {
                ExecStart = "${pkgs.poweralertd}/bin/poweralertd";
                Restart = "on-failure";
              };
            };
          })
        ];
      }
    ];
  };
}
