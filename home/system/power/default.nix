{pkgs, ...}: {
  home.packages = [pkgs.poweralertd];

  # Event-driven low-battery/critical/full notifications via UPower dbus signals
  # (thresholds set in nixos/utils.nix, services.upower.percentage*).
  systemd.user.services.poweralertd = {
    Unit.Description = "UPower-powered battery notifications";
    Service = {
      ExecStart = "${pkgs.poweralertd}/bin/poweralertd";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
