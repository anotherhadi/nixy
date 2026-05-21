{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nvf.homeManagerModules.default];
  programs.nvf = {
    enable = true;
    settings = {
      imports = [
        ./options.nix
        ./languages.nix
        ./picker.nix
        ./snacks.nix
        ./keymaps.nix
        ./utils.nix
        ./mini.nix
      ];
    };
  };
}
