{
  inputs,
  pkgs,
  pkgs-stable,
  pkgs-nur-hadi,
  system,
  ...
}: let
  devPackages = import ./dev-packages.nix {inherit pkgs pkgs-stable;};
  cyberPackages = import ./cybersecurity-packages.nix {inherit pkgs pkgs-stable pkgs-nur-hadi;};
in {
  packages.${system} = {
    dev = pkgs.buildEnv {
      name = "dev-tools";
      paths = devPackages;
    };
    cybersecurity = pkgs.buildEnv {
      name = "cybersecurity-tools";
      paths = cyberPackages;
    };
  };
}
