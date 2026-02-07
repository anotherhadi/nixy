# Caelestia Shell Home Manager Configuration
# See https://github.com/caelestia-dots/shell
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
    ./bindings.nix
    ./bar.nix
    ./launcher.nix
    ./appearance.nix
    ./scheme.nix
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

  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
