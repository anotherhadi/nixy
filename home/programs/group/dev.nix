{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages = import ./dev-packages.nix {inherit pkgs pkgs-stable;};
}
