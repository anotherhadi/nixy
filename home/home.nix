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
    ./lf
  ];

  home.username = "hadi"; # CHANGEME
  home.homeDirectory = "/home/hadi"; # CHANGEME

  home.packages = with pkgs; [
    swappy
    imv
    bc
    discord
    obsidian
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

    # Just cool
    cbonsai
    pipes
    cmatrix

    # Backup
    vscode
    firefox
  ];

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
