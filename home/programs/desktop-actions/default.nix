{pkgs, ...}: let
  waybar-toggle = pkgs.writeShellScriptBin "waybar-toggle" ''
    if pidof waybar > /dev/null; then
      pkill waybar
    else
      hyprctl dispatch exec waybar
    fi
  '';
in {
  home.packages = [waybar-toggle];

  xdg.desktopEntries = {
    focus-toggle = {
      name = "Focus Mode";
      exec = "focus-toggle";
      icon = "do-not-disturb-symbolic";
      comment = "Toggle focus mode";
      categories = ["System"];
      terminal = false;
    };

    nightshift-toggle = {
      name = "Night Shift";
      exec = "nightshift-toggle";
      icon = "night-light-symbolic";
      comment = "Toggle night shift";
      categories = ["System"];
      terminal = false;
    };

    mic-mute = {
      name = "Mute Microphone";
      exec = "swayosd-client --input-volume mute-toggle";
      icon = "microphone-sensitivity-muted-symbolic";
      comment = "Toggle microphone mute";
      categories = ["System"];
      terminal = false;
    };

    lock = {
      name = "Lock";
      exec = "hyprlock";
      icon = "system-lock-screen-symbolic";
      comment = "Lock the screen";
      categories = ["System"];
      terminal = false;
    };

    reboot = {
      name = "Reboot";
      exec = "systemctl reboot";
      icon = "system-restart-symbolic";
      comment = "Restart the system";
      categories = ["System"];
      terminal = false;
    };

    shutdown = {
      name = "Shutdown";
      exec = "systemctl poweroff";
      icon = "system-shutdown-symbolic";
      comment = "Power off the system";
      categories = ["System"];
      terminal = false;
    };

    hibernate = {
      name = "Hibernate";
      exec = "systemctl hibernate";
      icon = "drive-harddisk-symbolic";
      comment = "Hibernate the system";
      categories = ["System"];
      terminal = false;
    };

    waybar-toggle = {
      name = "Toggle Waybar";
      exec = "waybar-toggle";
      icon = "panel-applets-symbolic";
      comment = "Show or hide the status bar";
      categories = ["System"];
      terminal = false;
    };
  };
}
