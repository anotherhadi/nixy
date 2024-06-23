{ pkgs, config, ... }:

let

  remote-rebuild = pkgs.writeShellScriptBin "remote-rebuild" ''
    ssh jack -C "cd /home/hadi/.config/nixos && git pull && nixy-rebuild"
  '';

in { home.packages = with pkgs; [ remote-rebuild ]; }
