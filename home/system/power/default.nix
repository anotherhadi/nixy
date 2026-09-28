{
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

  home.packages = [pkgs.poweralertd scripts.power-cycle];

  xdg.desktopEntries.power-cycle = {
    name = "Power Profile";
    exec = "${scripts.power-cycle}/bin/power-cycle";
    icon = "power-profile-balanced-symbolic";
    comment = "Cycle power-saver / balanced / performance";
    categories = ["System"];
    terminal = false;
    settings.Keywords = "power;profile;performance;battery;";
  };

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
