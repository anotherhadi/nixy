{ inputs, pkgs, ... }: {

  home.packages = [
    inputs.superfile.packages.${pkgs.system}.default # CLI file manager
  ];
}
