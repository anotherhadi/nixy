# File runned at startup by Hyprland
{ pkgs, config, ... }:
let
  startup = pkgs.writeShellScriptBin "startup" ''
    # Startup is a script called by Hyprland on startup
    # Because HM enabling services suck.

    [[ ${toString config.var.sops} == "1" ]] && systemctl --user start sops-nix

    battery-watch &
    ${pkgs.waybar}/bin/waybar &


    wlr-randr --output "Unknown-1" --off # FIX: REMOVE WEIRD GHOST MONITOR
  '';

in { home.packages = [ startup ]; }
