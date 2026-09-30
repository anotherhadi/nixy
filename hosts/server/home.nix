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
    ++ [
      inputs.nvf-config.homeManagerModules.default # My vim config
      ../../home/tui/git/signing.nix # CHANGEME: Change the key or remove this file
      ./variables.nix # Mostly user-specific configuration
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
