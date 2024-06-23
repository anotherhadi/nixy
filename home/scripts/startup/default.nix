# File runned at startup by Hyprland
{ pkgs, config, ... }:
let
  startup = pkgs.writeShellScriptBin "startup" ''
    # Because HM enabling services suck.

    [[ ${toString config.var.sops} == "1" ]] && systemctl --user start sops-nix

    notify-system &
    ${pkgs.waybar}/bin/waybar &


    wlr-randr --output "Unknown-1" --off # FIX: REMOVE WEIRD GHOST MONITOR
  '';

in { home.packages = [ startup ]; }
