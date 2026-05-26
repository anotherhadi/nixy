{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}: {
  home.packages = import ./dev-packages.nix {
    inherit pkgs pkgs-stable inputs;
    system = pkgs.stdenv.hostPlatform.system;
  };
}
