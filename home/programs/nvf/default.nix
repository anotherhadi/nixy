{ inputs, ... }:
{
  imports = [
    inputs.nvf.homeManagerModules.default
    ./mini.nix
    ./options.nix
    ./languages
    ./snippets
    ./visual.nix
  ];

  programs.nvf = {
    enable = true;
  };
}
