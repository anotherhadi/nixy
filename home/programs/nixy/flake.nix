{
  pkgs,
  system,
  ...
}: {
  packages.${system}.nixy = import ./package.nix {
    inherit pkgs;
    configDirectory = "$HOME/.config/nixos";
  };

  homeManagerModules.nixy = {imports = [./default.nix];};
}
