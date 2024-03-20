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
    ./scripts
    ./neofetch
    ./spicetify
    ./theme
    ./wallpapers
    ./lf
    ./sops # REMOVE
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
      bitwarden
      vlc

      # Dev
      go
      cargo
      nodejs
      python3
      jq

      # Utils
      sops # Secrets
      age # Secrets
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
