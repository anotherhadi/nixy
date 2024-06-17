{ pkgs, config, ... }: {

  imports = [
    ../hosts/laptop/variables.nix

    # Programs
    ./programs/btop
    ./programs/cava
    ./programs/kitty
    ./programs/nvim
    ./programs/qutebrowser
    ./programs/spicetify

    # Scripts
    ./scripts # All scripts

    # System
    ./system/dunst
    ./system/git
    ./system/gtk
    ./system/hyprland
    ./system/shell
    ./system/sops/laptop.nix
    ./system/waybar
    ./system/wlogout
    ./system/wofi
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
      pfetch

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

    # Import wallpapers into $HOME/wallpapers
    file."wallpapers" = {
      recursive = true;
      source = ./wallpapers;
    };

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

}
