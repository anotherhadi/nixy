{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;

  nixy-rebuild = pkgs.writeShellScriptBin "nixy-rebuild" ''
    sudo nixos-rebuild switch --flake ${homedir}/.config/nixos#nixy
  '';

  nixy-upgrade = pkgs.writeShellScriptBin "nixy-upgrade" ''
    sudo nixos-rebuild switch --upgrade --flake ${homedir}/.config/nixos#nixy
  '';

  nixy-update = pkgs.writeShellScriptBin "nixy-update" ''
    cd ${homedir}/.config/nixos && sudo nix flake update
  '';

  nixy-gc = pkgs.writeShellScriptBin "nixy-gc" ''
    cd ${homedir}/.config/nixos && sudo nix-collect-garbage -d
  '';

  nixy-cb = pkgs.writeShellScriptBin "nixy-cb" ''
    sudo /run/current-system/bin/switch-to-configuration boot
  '';

in {
  home.packages = with pkgs; [
    nixy-rebuild
    nixy-upgrade
    nixy-update
    nixy-gc
    nixy-cb
  ];
}
