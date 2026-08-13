{
  config,
  inputs,
  ...
}: {
  imports = [
    # Mostly user-specific configuration
    ./variables.nix

    # Programs
    inputs.nvf-config.homeManagerModules.default
    ../../home/programs/tui/shell
    ../../home/programs/tui/git
    ../../home/programs/tui/git/lazygit.nix
    ../../home/programs/tui/nixy
    ../../home/programs/tui/nix-utils

    ../../home/programs/group/dev.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    # Don't touch this
    stateVersion = "24.05";
  };

  programs.home-manager.enable = true;

  programs.nixy = {
    enable = true;
    configDirectory = config.var.configDirectory;
  };
}
