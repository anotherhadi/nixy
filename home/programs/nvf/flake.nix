{
  inputs,
  pkgs,
  system,
  ...
}: let
  nvimConfig = inputs.nvf.lib.neovimConfiguration {
    inherit pkgs;
    modules = [
      ./options.nix
      ./languages.nix
      ./picker.nix
      ./snacks.nix
      ./keymaps.nix
      ./utils.nix
      ./mini.nix
    ];
  };
in {
  packages.${system}.nvim = nvimConfig.neovim;

  apps.${system}.nvim = {
    type = "app";
    program = "${nvimConfig.neovim}/bin/nvim";
  };
  defaultApp.${system} = {
    type = "app";
    program = "${nvimConfig.neovim}/bin/nvim";
  };

  homeManagerModules.nvim = {imports = [./default.nix];};
}
