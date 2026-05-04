{config, ...}: {
  imports = [
    # Programs
    ../../home/programs/brave
    ../../home/programs/proton
    ../../home/programs/proton/auto-start-vpn.nix
    ../../home/programs/ghostty
    ../../home/programs/nvf
    ../../home/programs/shell
    ../../home/programs/git
    ../../home/programs/git/lazygit.nix
    ../../home/programs/git/signing.nix # CHANGEME: Change the key or remove this file
    ../../home/programs/spicetify
    ../../home/programs/thunar
    ../../home/programs/nixy
    ../../home/programs/nightshift
    ../../home/programs/qutebrowser
    ../../home/programs/nix-utils

    ../../home/programs/group/basic-apps.nix
    ../../home/programs/group/cybersecurity.nix
    ../../home/programs/group/dev.nix
    ../../home/programs/group/misc.nix

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
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;
    file.".face" = {source = ./profile_picture.png;};

    sessionVariables = {
      AQ_DRM_DEVICES = "/dev/dri/card2:/dev/dri/card1"; # CHANGEME: Related to the GPU
    };

    # Don't touch this
    stateVersion = "24.05";
  };

  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-2,highres,0x0,1" # My internal laptop screen
    "desc:AOC U34G2G1 0x00000E06,3440x1440@99.98,auto,1" # My external monitor
  ];

  programs = {
    home-manager.enable = true;
    nixy = {
      enable = true;
      configDirectory = config.var.configDirectory;
    };
  };
}
