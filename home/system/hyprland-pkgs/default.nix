{pkgs, ...}:

{
  home.packages = with pkgs; [
    waybar
    quickshell
    hyprlock
    hypridle
    swaynotificationcenter
    tofi
    hyprpolkitagent
  ];
}
