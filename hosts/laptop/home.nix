{
  config,
  inputs,
  ...
}: {
  imports = [
    # Programs

    ## GUI
    ../../home/programs/gui/proton
    ../../home/programs/gui/proton/auto-start-vpn.nix
    ../../home/programs/gui/helium
    ../../home/programs/gui/thunar
    ../../home/programs/gui/pkgs.nix

    ## TUI
    inputs.nvf-config.homeManagerModules.default
    ../../home/programs/tui/ghostty
    ../../home/programs/tui/ilovetui
    ../../home/programs/tui/shell
    ../../home/programs/tui/git
    ../../home/programs/tui/git/lazygit.nix
    ../../home/programs/tui/git/signing.nix # CHANGEME: Change the key or remove this file
    ../../home/programs/tui/nixy
    ../../home/programs/tui/nix-utils
    ../../home/programs/tui/spotatui
    ../../home/programs/tui/yazi
    ../../home/programs/tui/pkgs.nix

    ## GROUPS
    ../../home/programs/group/cybersecurity.nix
    ../../home/programs/group/dev.nix

    # System (Desktop environment like stuff)
    ../../home/system/hyprlock
    ../../home/system/hyprland
    ../../home/system/waybar
    ../../home/system/swaync
    ../../home/system/tofi
    ../../home/system/mime
    ../../home/system/termfilechooser
    ../../home/system/udiskie
    ../../home/system/clipboard
    ../../home/system/hypridle

    ./variables.nix # Mostly user-specific configuration
    ./secrets # CHANGEME: You should probably remove this line, this is where I store my secrets
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;
    file.".face" = {
      source = ./profile_picture.png;
    };

    sessionVariables = {
      AQ_DRM_DEVICES = "/dev/dri/card2:/dev/dri/card1"; # CHANGEME: Related to the GPU
    };

    # Don't touch this
    stateVersion = "26.05";
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
