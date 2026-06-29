{pkgs-stable, ...}: {
  programs.direnv = {
    enable = true;
    package = pkgs-stable.direnv;
    nix-direnv = {
      enable = true;
      package = pkgs-stable.nix-direnv;
    };
  };
}
