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

  home = {
    username = "hadi"; # CHANGEME
    homeDirectory = "/home/hadi"; # CHANGEME

    packages = with pkgs; [
      swappy
      imv
      discord
      obsidian
      btop
      xfce.thunar

      # Dev
      go
      cargo
      nodejs
      python3

      # Utils
      fd
      bc
      gcc
      blueman
      unzip
      xdg_utils
      tldr
      wget
      curl
      ripgrep

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix

      # Backup
      vscode
      firefox
    ];

    stateVersion = "23.11";
  };
  programs.home-manager.enable = true;
}
