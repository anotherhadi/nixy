{
  config,
  inputs,
  ...
}: {
  imports = [
    ## TUI
    inputs.nvf-config.homeManagerModules.default
    ../../home/programs/tui/ilovetui
    ../../home/programs/tui/shell
    ../../home/programs/tui/git
    ../../home/programs/tui/git/lazygit.nix
   # ../../home/programs/tui/git/signing.nix # CHANGEME: Change the key or remove this file
    ../../home/programs/tui/nixy
    ../../home/programs/tui/nix-utils
    ../../home/programs/tui/elio
    ../../home/programs/tui/wikiman
    ../../home/programs/tui/pkgs.nix

    ../../home/programs/group/dev.nix

    # Mostly user-specific configuration
    ./variables.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    # Don't touch this
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;

  programs.nixy = {
    enable = true;
    configDirectory = config.var.configDirectory;
  };
}
