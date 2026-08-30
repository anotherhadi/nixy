# Clipboard history: cliphist watches the Wayland clipboard and stores every
# entry (text + images) so it can be recalled later via the `clipboard-menu`
# script (tofi). Uses the home-manager module so the watcher services are
# managed the same way as swaync/hypridle.
{pkgs, ...}: {
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
}
