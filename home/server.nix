{ pkgs, ... }:
let variable = import ../variables.nix;
in {

  imports = [
    ./themes/server.nix
    ./system/server.nix
    ./scripts/server.nix
    ./apps/server.nix
  ];

  home = {
    username = variable.username;
    homeDirectory = variable.homeDirectory;

    packages = with pkgs; [
      btop

      # Dev
      go
      cargo
      nodejs
      python3
      jq

      # Utils
      sops # Secrets
      age # Secrets
      fd
      bc
      gcc
      zip
      unzip
      wget
      curl
    ];

    stateVersion = variable.server.stateVersion;
  };
  programs.home-manager.enable = true;
}
