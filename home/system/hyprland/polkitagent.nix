# HyprPolkitAgent is a simple polkit agent for wayland compositors
{pkgs-stable, ...}: {
  home.packages = with pkgs-stable; [hyprpolkitagent];

  wayland.windowManager.hyprland.settings.exec-once = ["systemctl --user start hyprpolkitagent"];
}
