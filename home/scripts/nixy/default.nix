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

  heaven-rebuild = pkgs.writeShellScriptBin "heaven-rebuild" ''
    sudo nixos-rebuild switch --flake ${homedir}/.config/nixos#heaven
  '';

  heaven-upgrade = pkgs.writeShellScriptBin "heaven-upgrade" ''
    sudo nixos-rebuild switch --upgrade --flake ${homedir}/.config/nixos#heaven
  '';

  heaven-update = pkgs.writeShellScriptBin "heaven-update" ''
    cd ${homedir}/.config/nixos && sudo nix flake update
  '';

  heaven-gc = pkgs.writeShellScriptBin "heaven-gc" ''
    cd ${homedir}/.config/nixos && sudo nix-collect-garbage -d
  '';

  heaven-cb = pkgs.writeShellScriptBin "heaven-cb" ''
    sudo /run/current-system/bin/switch-to-configuration boot
  '';

in {
  home.packages = with pkgs; [
    nixy-rebuild
    nixy-upgrade
    nixy-update
    nixy-gc
    nixy-cb
    heaven-rebuild
    heaven-upgrade
    heaven-update
    heaven-gc
    heaven-cb
  ];
}
