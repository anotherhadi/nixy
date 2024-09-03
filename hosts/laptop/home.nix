{ pkgs, config, ... }: {

  imports = [
    ./variables.nix

    # Programs
    ../../home/programs/kitty
    ../../home/programs/nvim
    ../../home/programs/qutebrowser
    ../../home/programs/shell
    ../../home/programs/fetch
    ../../home/programs/git
    # ../../home/programs/spicetify TODO: broken
    ../../home/programs/btop
    ../../home/programs/cava
    ../../home/programs/nextcloud

    # Scripts
    ../../home/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../home/system/hyprland
    ../../home/system/gtk
    ../../home/system/wlogout
    ../../home/system/wofi
    ../../home/system/batsignal
    ../../home/system/zathura
    ../../home/system/mime
    ../../home/system/udiskie
    ../../home/system/clipman

    ./secrets # You should probably remove this line
  ];

  home = {
    inherit (config.var) username;
    inherit (config.var) homeDirectory;

    packages = with pkgs; [
      # Apps
      discord
      xfce.thunar
      bitwarden
      vlc

      # Dev
      go
      nodejs
      python3
      jq
      nurl
      prefetch-npm-deps
      figlet

      # Utils
      zip
      unzip
      glow
      optipng
      pfetch
      pandoc
      tailscale

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix

      # Backup
      vscode
      firefox
      neovide
    ];

    # Import wallpapers into $HOME/wallpapers
    file."wallpapers" = {
      recursive = true;
      source = ../../home/wallpapers;
    };

    # Import my profile picture, used by the hyprpanel dashboard
    file.".profile_picture.png" = { source = ./profile_picture.png; };

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
