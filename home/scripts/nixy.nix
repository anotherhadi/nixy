{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;

  nixy-rebuild = pkgs.writeShellScriptBin "nixy-rebuild" ''
    sudo nixos-rebuild switch --flake ${homedir}/.config/nixos#nixy
  '';
  nixy-edit = pkgs.writeShellScriptBin "nixy-edit" ''
    $EDITOR ${homedir}/.config/nixos/
  '';

  nixy-update = pkgs.writeShellScriptBin "nixy-update" ''
    cd ${homedir}/.config/nixos && sudo nix flake update
  '';

  nixy-gc = pkgs.writeShellScriptBin "nixy-gc" ''
    cd ${homedir}/.config/nixos && sudo nix-collect-garbage -d
  '';

in {
  home.packages = with pkgs; [ nixy-rebuild nixy-edit nixy-update nixy-gc ];
}
