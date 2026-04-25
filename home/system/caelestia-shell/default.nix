# Caelestia Shell Home Manager Configuration
# See https://github.com/caelestia-dots/shell
{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    ./bar.nix
    ./launcher.nix
    ./appearance.nix
    ./scheme.nix
    ./swappy.nix
  ];

  programs.caelestia = {
    enable = true;
    systemd.enable = false;
    settings = {
      services.weatherLocation = "Paris";
      general = {
        apps = {
          terminal = ["ghostty"];
          audio = ["pavucontrol"];
          explorer = ["thunar"];
        };
        idle = {
          timeouts = [];
        };
      };
    };
    cli = {
      enable = true;
      settings.theme = {
        enableTerm = false;
        enableDiscord = false;
        enableSpicetify = false;
        enableBtop = false;
        enableCava = false;
        enableHypr = false;
        enableGtk = false;
        enableQt = false;
      };
    };
  };

  home.packages = with pkgs; [
    gpu-screen-recorder
  ];

  wayland.windowManager.hyprland.settings.exec-once = [
    "uwsm app -- caelestia resizer -d"
    "uwsm app -- caelestia shell -d"
    "caelestia scheme set -n onedark"
    "caelestia scheme set -n custom"
  ];

  # shell.json is managed by home-manager (read-only symlink) but caelestia
  # needs to write to it at runtime: replace the symlink with a mutable copy
  home.activation.caelestiaWritableShellConfig = lib.hm.dag.entryAfter ["linkGeneration"] ''
    if [ -L "$HOME/.config/caelestia/shell.json" ]; then
      $DRY_RUN_CMD cp --remove-destination \
        "$(readlink -f "$HOME/.config/caelestia/shell.json")" \
        "$HOME/.config/caelestia/shell.json"
    fi
  '';

  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
