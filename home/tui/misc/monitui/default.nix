# Monitui allows you to edit hyprland's monitor configuration
{pkgs, ...}: {
  home.packages = [
    pkgs.nur.repos.anotherhadi.monitui
  ];

  xdg.desktopEntries.monitui = {
    name = "monitui";
    exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${pkgs.nur.repos.anotherhadi.monitui}/bin/monitui";
    comment = "Delightfully minimal TUI for wrangling Hyprland monitors";
    categories = ["Settings" "HardwareSettings"];
    terminal = false;
    settings.Keywords = "hyprland;monitor;display;screen;resolution";
  };
}
