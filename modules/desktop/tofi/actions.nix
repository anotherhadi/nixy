{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({
      pkgs,
      scripts,
      ...
    }: {
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
          exec = "${scripts.term}/bin/term ${pkgs.nur.repos.anotherhadi.settuings}/bin/settuings";
        };
      };
    })
  ];
}
