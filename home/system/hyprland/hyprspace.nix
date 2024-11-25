{ inputs, pkgs, ... }: {

  wayland.windowManager.hyprland = {
    plugins = [ inputs.hyprspace.packages.${pkgs.system}.Hyprspace ];
    settings = {
      plugin = { overview = { autoDrag = false; }; };

      bind = [
        "$mod,TAB, overview:toggle" # Overview

      ];
    };
  };
}
