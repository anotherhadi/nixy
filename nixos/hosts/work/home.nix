{
  config,
  inputs,
  lib,
  ...
}: {
  imports = [
    # Programs

    ## GUI
    ../../home/programs/gui/proton
    ../../home/programs/gui/helium
    ../../home/programs/gui/pkgs.nix

    ## TUI
    inputs.nvf-config.homeManagerModules.default
    ../../home/programs/tui/ghostty
    ../../home/programs/tui/ilovetui
    ../../home/programs/tui/shell
    ../../home/programs/tui/git
    ../../home/programs/tui/git/lazygit.nix
    ../../home/programs/tui/nixy
    ../../home/programs/tui/nix-utils
    ../../home/programs/tui/spotatui
    ../../home/programs/tui/elio
    ../../home/programs/tui/wikiman
    ../../home/programs/tui/navi
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
    ../../home/system/udiskie
    ../../home/system/termfilechooser
    ../../home/system/clipboard
    ../../home/system/hypridle

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
