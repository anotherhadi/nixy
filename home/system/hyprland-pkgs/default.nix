{pkgs, ...}:

{
  xdg.configFile.hypr.source = ../../../dotfiles/hyprland;

  home.packages = with pkgs; [
    waybar
    quickshell
    hyprlock
    hypridle
    swaynotificationcenter
    tofi
    hyprpolkitagent
    lua
    bemenu
    hyprpaper
  ];
}
