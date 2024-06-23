{ pkgs, config, ... }:

let

  remote-rebuild = pkgs.writeShellScriptBin "remote-rebuild" ''
    ssh jack -S -C "cd /home/hadi/.config/nixos && git pull && sudo -S nixos-rebuild switch --flake ~/.config/nixos#jack"
  '';

  remote-push = pkgs.writeShellScriptBin "remote-push" ''
    cd ~/.config/nixos && git add . && git commit -m "update" && git push
    remote-rebuild
  '';

in { home.packages = [ remote-rebuild remote-push ]; }
