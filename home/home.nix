{ config, pkgs, ... }: {

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
    ./nextcloud
    ./scripts
    ./neofetch
    ./spicetify
    ./variables/theme
    ./wallpaper
  ];

  home.username = "hadi";
  home.homeDirectory = "/home/hadi";

  home.packages = with pkgs; [
    swappy
    imv
    discord
    obsidian
    ranger
    fd
    btop
    go
    cargo
    nodejs
    python3
    unzip
    blueman
    gcc
    peaclock
    xdg_utils
    tldr
    qt5ct
    libva
    wget
    ripgrep

    # Backup
    vscode
    firefox
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
