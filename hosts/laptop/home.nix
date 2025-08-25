{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Mostly user-specific configuration
    ./variables.nix

    # Programs
    ../../home/programs/kitty
    ../../home/programs/nvf
    ../../home/programs/shell
    ../../home/programs/fetch
    ../../home/programs/git
    ../../home/programs/git/signing.nix
    ../../home/programs/spicetify
    ../../home/programs/thunar
    ../../home/programs/lazygit
    ../../home/programs/zen
    ../../home/programs/discord
    ../../home/programs/tailscale

    # Scripts
    ../../home/scripts # All scripts

    # System (Desktop environment like stuff)
    ../../home/system/hyprland
    ../../home/system/hyprlock
    ../../home/system/hyprpanel
    ../../home/system/hyprpaper
    ../../home/system/wofi
    ../../home/system/zathura
    ../../home/system/mime
    ../../home/system/udiskie
    # ../../home/system/hypridle
    # ../../home/system/clipman

    ./secrets # CHANGEME: You should probably remove this line, this is where I store my secrets
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    packages = with pkgs; [
      # Apps
      bitwarden # Password manager
      vlc # Video player
      blanket # White-noise app
      obsidian # Note taking app
      planify # Todolists
      gnome-calendar # Calendar
      textpieces # Manipulate texts
      curtail # Compress images
      resources # Ressource monitor
      gnome-clocks # Clocks app
      gnome-text-editor # Basic graphic text editor
      mpv # Video player
      brave # Web browser

      # Privacy
      session-desktop # Session app, private messages
      protonvpn-gui
      protonvpn-cli
      proton-pass
      protonmail-desktop
      proton-authenticator

      # Dev
      go
      bun
      nodejs
      python3
      jq
      just
      pnpm
      air
      duckdb

      # Utils
      zip
      unzip
      optipng
      jpegoptim
      pfetch
      btop
      fastfetch

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix

      # Backup
      vscode
    ];

    # Import my profile picture, used by the hyprpanel dashboard
    file.".face.icon" = {source = ./profile_picture.png;};

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
