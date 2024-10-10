{ inputs, pkgs, ... }: {
  home.packages = [ inputs.hyprswitch.packages."${pkgs.system}".default ];

  wayland.windowManager.hyprland.settings.exec-once = [
    "${inputs.hyprswitch.packages."${pkgs.system}".default}/bin/hyprswitch init"
  ];

}
