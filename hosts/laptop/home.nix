{ pkgs, config, ... }: {

  imports = [
    ./variables.nix

    # Programs
    ../../home/programs/btop
    ../../home/programs/cava
    ../../home/programs/kitty
    ../../home/programs/nextcloud
    ../../home/programs/nvim
    ../../home/programs/qutebrowser
    ../../home/programs/spicetify
    ../../home/programs/zathura
    ../../home/programs/shell
    ../../home/programs/git

    # Scripts
    ../../home/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../home/system/dunst
    ../../home/system/gtk
    ../../home/system/hyprland
    ../../home/system/waybar
    ../../home/system/wlogout
    ../../home/system/wofi
    ../../home/system/mime
    ../../home/system/udiskie

    ./sops.nix # You should probably remove this line
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
      nextcloud-client
      tailscale

      # Dev
      go
      cargo
      nodejs
      python3
      jq
      git-ignore
      nurl
      prefetch-npm-deps
      figlet

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
      usbutils

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
      source = ../../home/wallpapers;
    };

    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
