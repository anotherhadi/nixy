{
  programs.caelestia.settings = {
    session.commands = {
      logout = ["loginctl" "terminate-user" ""];
      shutdown = ["systemctl" "poweroff"];
      hibernate = ["systemctl" "hibernate"];
      reboot = ["systemctl" "reboot"];
    };
    launcher = {
      actionPrefix = "/";
      actions = [
        {
          name = "Calculator";
          icon = "calculate";
          description = "Do simple math equations (powered by Qalc)";
          command = ["autocomplete" "calc"];
          enabled = true;
          dangerous = false;
        }
        {
          name = "Shutdown";
          icon = "power_settings_new";
          description = "Shutdown the system";
          command = ["systemctl" "poweroff"];
          enabled = true;
          dangerous = true;
        }
        {
          name = "Reboot";
          icon = "cached";
          description = "Reboot the system";
          command = ["systemctl" "reboot"];
          enabled = true;
          dangerous = true;
        }
        {
          name = "Logout";
          icon = "exit_to_app";
          description = "Log out of the current session";
          command = ["loginctl" "terminate-user" ""];
          enabled = true;
          dangerous = true;
        }
        {
          name = "Lock";
          icon = "lock";
          description = "Lock the current session";
          command = ["loginctl" "lock-session"];
          enabled = true;
          dangerous = false;
        }
        {
          name = "Sleep";
          icon = "bedtime";
          description = "Suspend then hibernate";
          command = ["systemctl" "suspend-then-hibernate"];
          enabled = true;
          dangerous = false;
        }
        {
          name = "Restart caelestia";
          icon = "cached";
          description = "Restart caelestia";
          command = ["hyprctl" "dispatch" "exec" "caelestia-shell kill | sleep 1 | caelestia-shell"];
          enabled = true;
          dangerous = false;
        }
        {
          name = "Emoji Picker";
          icon = "mood";
          description = "Toggle the emoji picker";
          command = ["caelestia" "emoji" "-p"];
          enabled = true;
          dangerous = false;
        }
        {
          name = "Clipboard History";
          icon = "content_paste";
          description = "Toggle the clipboard history";
          command = ["caelestia" "clipboard"];
          enabled = true;
          dangerous = false;
        }
        {
          name = "Delete from Clipboard History";
          icon = "content_paste_off";
          description = "Delete a line from the clipboard history";
          command = ["caelestia" "clipboard"];
          enabled = true;
          dangerous = false;
        }
        {
          name = "Night Shift";
          icon = "moon_stars";
          description = "Toggle Night Shift, the blue light filter";
          command = ["nightshift-toggle"];
          enabled = true;
          dangerous = false;
        }
        {
          name = "Hyprpicker";
          icon = "colorize";
          description = "Pick an hex color";
          command = ["hyprpicker" "-a"];
          enabled = true;
          dangerous = false;
        }
      ];
      dragThreshold = 50;
      enableDangerousActions = false;
      maxShown = 7;
      specialPrefix = "@";
      useFuzzy = {
        apps = false;
        actions = false;
        schemes = false;
        variants = false;
        wallpapers = false;
      };
      showOnHover = false;
      hiddenApps = [];
    };
  };
}
