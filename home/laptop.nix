{ pkgs, config, ... }: {

  imports = [
    ../hosts/laptop/variables.nix
    ./system/laptop.nix
    ./scripts/laptop.nix
    ./programs/laptop.nix
  ];

  home = {
    inherit (config.var) username;
    inherit (config.var) homeDirectory;

    packages = with pkgs; [
      swappy
      imv
      discord
      obsidian
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
      fd
      bc
      gcc
      blueman
      zip
      unzip
      xdg_utils
      wget
      curl
      wf-recorder
      glow
      nwg-displays
      wireguard-tools
      bitwarden-cli
      optipng

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix

      # Backup
      vscode
      tor-browser
      firefox
      neovide
    ];

    file."wallpapers" = {
      recursive = true;
      source = ./wallpapers;
    };

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

}
