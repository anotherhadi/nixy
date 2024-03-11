{ config, pkgs, ...}: {
    home.username = "hadi";
    home.homeDirectory = "/home/hadi";

    home.packages = with pkgs; [
    vscode
    ];

    home.stateVersion = "23.11";
    programs.home-manager.enable = true;

    imports = [
      ./hyprland
      ./nvim
      ./waybar
      ./kitty
      ./dunst
      ./wlogout
      ./wofi
      ./qutebrowser
      ./git
      ./shell
      ./misc
    ];
}
