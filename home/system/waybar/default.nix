{ pkgs, ... }: {
  imports = [
    ./settings.nix
    ./style.nix
  ];

  programs.waybar.enable = true;
  stylix.targets.waybar.enable = false;

  home.packages = with pkgs; [
    playerctl
    pavucontrol
    blueman
    swayosd
  ];

  wayland.windowManager.hyprland.settings.exec-once = [
    "waybar"
    "swayosd-server"
  ];
}
