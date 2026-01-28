{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    # Programs
    ../../home/programs/brave
    ../../home/programs/proton
    ../../home/programs/ghostty
    ../../home/programs/nvf
    ../../home/programs/shell
    ../../home/programs/fetch
    ../../home/programs/git
    ../../home/programs/git/lazygit.nix
    # ../../home/programs/git/signing.nix # Change the key or remove this file
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
      libnotify # notify-send
      killall
      steam

      # Dev
      go
      bun
      docker
      nodejs
      python3
      jq
      just
      air
      duckdb

      # Just cool
      peaclock
      cbonsai
      pipes
      cmatrix
      fastfetch
      yazi

      # Backup
      vscode
      vivaldi

      inputs.zen-browser.packages."${stdenv.hostPlatform.system}".twilight
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
