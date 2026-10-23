# Udiskie is a simple daemon that uses udisks to automatically mount removable storage devices.
{
  flake.modules.nixos.desktop.services.udisks2.enable = true;
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      packages = [pkgs.udiskie];

      xdg.config.files."udiskie/config.yml" = {
        generator = (pkgs.formats.yaml {}).generate "udiskie-config.yml";
        value.program_options = {
          automount = true;
          notify = false;
          tray = false;
        };
      };

      systemd.services.udiskie = {
        description = "udiskie mount daemon";
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        serviceConfig.ExecStart = "${pkgs.udiskie}/bin/udiskie";
      };
    })
  ];
}
