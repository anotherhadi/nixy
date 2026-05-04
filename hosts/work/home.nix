{config, ...}: {
  imports = [
    # Programs
    ../../home/programs/brave
    ../../home/programs/proton
    ../../home/programs/ghostty
    ../../home/programs/nvf
    ../../home/programs/shell
    ../../home/programs/git
    ../../home/programs/git/lazygit.nix
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

    # Don't touch this
    stateVersion = "24.05";
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
  };
}
