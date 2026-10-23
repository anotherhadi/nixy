{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      systemd.services.hyprpolkitagent = {
        description = "Polkit authentication agent";
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        serviceConfig = {
          ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart = "on-failure";
        };
      };
    })
  ];
}
