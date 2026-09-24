{
  config,
  inputs,
  lib,
  ...
}: let
  utils = import ../../home/lib/utils.nix {inherit lib;};
in {
  imports =
    utils.importAll ../../home/tui
    ++ utils.importAll ../../home/gui
    ++ utils.importAll ../../home/system # System (Desktop environment like stuff)
    ++ [
      inputs.nvf-config.homeManagerModules.default # My vim config
      ../../home/tui/git/signing.nix # CHANGEME: Change the key or remove this file
      ./variables.nix # Mostly user-specific configuration
    ];

  # TODO: test taskwarrior avec l'application ios et le serveur selfhost

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    persistence."/persist" = lib.mkIf (config.var.impermanenceEnabled or false) {
      directories = [
        ".config/nixos" # this repo itself (nixy manages it here)
        ".local/share"
        ".local/state"
        ".cache"
        ".steam"
        "Notes"
        "Music"
        "Projects"
        "Documents"
        "Downloads"
        "Pictures"
        "Videos"
      ];

      files = [
        ".ssh/known_hosts"
        ".config/sops/age/keys.txt"
      ];
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
