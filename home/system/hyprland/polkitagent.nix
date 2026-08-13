# HyprPolkitAgent is a simple polkit agent for wayland compositors
{pkgs, ...}: {
  home.packages = with pkgs; [hyprpolkitagent];

  wayland.windowManager.hyprland.settings.exec-once = ["systemctl --user start hyprpolkitagent"];
}
