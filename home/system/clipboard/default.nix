# Clipboard history: cliphist watches the Wayland clipboard and stores every entry
{
  pkgs,
  scripts,
  ...
}: {
  home.packages = [pkgs.wl-clipboard];

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  systemd.user.services.cliphist-wipe = {
    Unit = {
      Description = "Wipe cliphist history on login and logout";
      After = ["cliphist.service"];
    };
    Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.cliphist}/bin/cliphist wipe";
      ExecStop = "${pkgs.cliphist}/bin/cliphist wipe";
    };
    Install.WantedBy = ["default.target"];
  };

  xdg.desktopEntries = {
    clipboard-menu = {
      name = "Clipboard History";
      exec = "${scripts.clipboard-menu}/bin/clipboard-menu";
      icon = "edit-paste-symbolic";
      comment = "Pick a past clipboard entry";
      categories = ["Utility"];
      terminal = false;
      settings.Keywords = "clipboard;history;paste;cliphist;";
    };

    clipboard-wipe = {
      name = "Clear Clipboard History";
      exec = "${pkgs.cliphist}/bin/cliphist wipe";
      icon = "edit-clear-all-symbolic";
      comment = "Delete all clipboard history entries";
      categories = ["Utility"];
      terminal = false;
      settings.Keywords = "clipboard;history;clear;wipe;delete;cliphist;";
    };
  };
}
