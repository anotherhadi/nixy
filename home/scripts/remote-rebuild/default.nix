{ pkgs, config, ... }:

let

  remote-rebuild = pkgs.writeShellScriptBin "remote-rebuild" ''
    ssh jack -S -C "cd /home/hadi/.config/nixos && git pull && sudo -S nixos-rebuild switch --flake ~/.config/nixos#jack"
  '';

in { home.packages = with pkgs; [ remote-rebuild ]; }
