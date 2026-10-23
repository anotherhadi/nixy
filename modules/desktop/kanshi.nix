# Kanshi applies output profiles
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      packages = [pkgs.kanshi];

      sway.config = ''
        exec_always ${pkgs.kanshi}/bin/kanshictl reload
      '';

      systemd.services.kanshi = {
        description = "kanshi output profiles";
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        unitConfig.ConditionPathExists = "%h/.config/kanshi/config";
        serviceConfig = {
          ExecStart = "${pkgs.kanshi}/bin/kanshi";
          Restart = "on-failure";
        };
      };
    })
  ];
}
