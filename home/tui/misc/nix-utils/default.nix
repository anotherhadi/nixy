{inputs, ...}: {
  imports = [inputs.nix-index-database.homeModules.default];
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
