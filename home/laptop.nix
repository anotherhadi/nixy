{ pkgs, ... }:
let variable = import ../variables.nix;
in {

  imports = [
    ./system/laptop.nix
    ./scripts/laptop.nix
    ./apps/laptop.nix
    ./themes/nixy.nix
  ];

  home = {
    username = variable.username;
    homeDirectory = variable.homeDirectory;

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
      zip
      unzip
      xdg_utils
      wget
      curl
      neovide
      wf-recorder
      glow

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix

      # Backup
      vscode
      firefox
      tor-browser
    ];

    stateVersion = variable.stateVersion;
  };
  programs.home-manager.enable = true;
}
