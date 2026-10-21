# Monitui allows you to edit hyprland's monitor configuration
{aspects, ...}: {
  flake.modules.nixos.monitui = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: let
        monitui = pkgs.nur.repos.anotherhadi.monitui;
      in {
        packages = [
          monitui
          (pkgs.makeDesktopItem {
            name = "monitui";
            desktopName = "monitui";
            exec = "${pkgs.ghostty}/bin/ghostty +new-window -e ${monitui}/bin/monitui";
            comment = "Delightfully minimal TUI for wrangling Hyprland monitors";
            categories = ["Settings" "HardwareSettings"];
            terminal = false;
            keywords = ["hyprland" "monitor" "display" "screen" "resolution"];
          })
        ];
      })
    ];
  };
}
