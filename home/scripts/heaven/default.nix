{ pkgs, config, ... }:

let
  homedir = config.home.homeDirectory;

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

  remote-rebuild = pkgs.writeShellScriptBin "remote-rebuild" ''
    ssh -t heaven "cd ~/.config/nixos && git pull && heaven-rebuild"
  '';

in {
  home.packages = with pkgs; [
    heaven-rebuild
    heaven-upgrade
    heaven-update
    heaven-gc
    heaven-cb
    remote-rebuild
  ];
}
