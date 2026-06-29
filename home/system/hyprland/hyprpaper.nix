# Hyprpaper is used to set the wallpaper on the system
{pkgs-stable, lib, ...}: {
  # The wallpaper is set by stylix
  services.hyprpaper = {
    enable = true;
    package = pkgs-stable.hyprpaper;
    settings = {
      ipc = "on";
      splash = false;
    };
  };
  systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";

  wayland.windowManager.hyprland.settings.exec-once = [
    "systemctl --user enable --now hyprpaper.service"
  ];
}
