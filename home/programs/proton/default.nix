{pkgs, ...}: {
  home.packages = with pkgs; [
    protonvpn-gui
    proton-pass
  ];

  # Auto-start Proton VPN
  wayland.windowManager.hyprland.settings.exec-once = [
    "protonvpn-app --start-minimized &"
  ];
}
