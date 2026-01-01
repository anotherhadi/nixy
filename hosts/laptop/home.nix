{
  pkgs,
  config,
  ...
}: {
  imports = [
    # Programs
    ../../home/programs/vivaldi
    ../../home/programs/proton
    ../../home/programs/ghostty
    ../../home/programs/nvf
    ../../home/programs/shell
    ../../home/programs/fetch
    ../../home/programs/git
    ../../home/programs/git/lazygit.nix
    ../../home/programs/git/signing.nix # Change the key or remove this file
    ../../home/programs/spicetify
    ../../home/programs/thunar
    ../../home/programs/discord
    ../../home/programs/nixy
    ../../home/programs/zathura
    ../../home/programs/nightshift
    ../../home/programs/group/cybersecurity.nix

    # System (Desktop environment like stuff)
    ../../home/system/hyprland
    ../../home/system/caelestia-shell
    ../../home/system/hyprpaper
    ../../home/system/mime
    ../../home/system/udiskie

    ./variables.nix # Mostly user-specific configuration
    ./secrets # CHANGEME: You should probably remove this line, this is where I store my secrets
  ];

  home = {
    packages = with pkgs; [
      # Apps
      vlc # Video player
      blanket # White-noise app
      obsidian # Note taking app
      textpieces # Manipulate texts
      resources # Ressource monitor
      gnome-clocks # Clocks app
      gnome-text-editor # Basic graphic text editor
      mpv # Video player
      ticktick # Todo app
      session-desktop # Session app, private messages
      signal-desktop # Signal app, private messages
      stirling-pdf # TODO: Server version
      calibre

      # Dev
      go
      bun
      docker
      nodejs
      python3
      jq
      just
      pnpm
      air
      duckdb

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix
      fastfetch

      # Backup
      vscode
      brave
    ];

    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    # Import a profile picture, used by the caelestia dashboard
    file.".face" = {source = ./profile_picture.png;};

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;
}
