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
              ${scripts.osd}/bin/osd "$OSD_TEXT" power
            '';

            packages = [pkgs.poweralertd];
            launcher.power-cycle.name = "Power Profile";

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
