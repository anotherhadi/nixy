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
      ./variables.nix # Mostly user-specific configuration
    ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    persistence."/persist" = lib.mkIf (config.var.impermanenceEnabled or false) {
      directories = [
        ".config/nixos" # this repo itself (nixy manages it here)
        ".local/share"
        ".local/state"
        ".cache"
        "Notes"
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

    # Don't touch this
    stateVersion = "26.05";
  };

  wayland.windowManager.hyprland.settings.monitor = [
    "desc:Philips Consumer Electronics Company PHL 221B8L ZV02144013987,highres,0x0,1"
  ];

  programs = {
    home-manager.enable = true;
    nixy = {
      enable = true;
      configDirectory = config.var.configDirectory;
    };

    git.includes = [
      {
        condition = "hasconfig:remote.*.url:**";
        contents.user = {
          name = "Hadrien";
          email = "hadi@example.fr";
        };
      }
      {
        condition = "hasconfig:remote.*.url:git@github.com:*/**";
        contents.user = {
          name = config.var.git.username;
          email = config.var.git.email;
        };
      }
    ];
  };
}
