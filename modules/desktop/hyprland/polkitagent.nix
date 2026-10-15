# HyprPolkitAgent is a simple polkit agent for wayland compositors
{
  flake.modules.nixos.desktop.hjem.extraModules = [
    ({pkgs, ...}: {
      packages = [pkgs.hyprpolkitagent];

      hyprland.settings.exec-once = ["systemctl --user start hyprpolkitagent"];
    })
  ];
}
