{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      launcher = {
        reboot = {
          name = "Reboot";
          exec = "systemctl reboot";
        };
        suspend = {
          name = "Suspend";
          exec = "systemctl suspend";
        };
        shutdown = {
          name = "Shutdown";
          exec = "systemctl poweroff";
        };
        hibernate = {
          name = "Hibernate";
          exec = "systemctl hibernate";
        };
        logout = {
          name = "Logout";
          exec = "${pkgs.uwsm}/bin/uwsm stop";
        };
        settuings = {
          name = "Settings";
          exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs.nur.repos.anotherhadi.settuings}/bin/settuings";
        };
      };
    })
  ];
}
