{config, ...}: let
  animationSpeed = config.theme.animation-speed;

  animationDuration =
    if animationSpeed == "slow"
    then "4"
    else if animationSpeed == "medium"
    then "2.5"
    else "1.5";
  borderDuration =
    if animationSpeed == "slow"
    then "10"
    else if animationSpeed == "medium"
    then "6"
    else "3";
in {
  wayland.windowManager.hyprland.settings = {
    animations = {
      enabled = true;
      bezier = [
        "linear, 0, 0, 1, 1"
        "md3_standard, 0.2, 0, 0, 1"
        "md3_decel, 0.05, 0.7, 0.1, 1"
        "md3_accel, 0.3, 0, 0.8, 0.15"
        "overshot, 0.05, 0.9, 0.1, 1.1"
        "crazyshot, 0.1, 1.5, 0.76, 0.92"
        "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
        "menu_decel, 0.1, 1, 0, 1"
        "menu_accel, 0.38, 0.04, 1, 0.07"
        "easeInOutCirc, 0.85, 0, 0.15, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutExpo, 0.16, 1, 0.3, 1"
        "softAcDecel, 0.26, 0.26, 0.15, 1"
        "md2, 0.4, 0, 0.2, 1"
      ];

      animation = [
        "windows, 1, ${animationDuration}, md3_decel, popin 60%"
        "windowsIn, 1, ${animationDuration}, md3_decel, popin 60%"
        "windowsOut, 1, ${animationDuration}, md3_accel, popin 60%"
        "border, 1, ${borderDuration}, default"
        "fade, 1, ${animationDuration}, md3_decel"
        "layersIn, 1, ${animationDuration}, menu_decel, slide"
        "layersOut, 1, ${animationDuration}, menu_accel"
        "fadeLayersIn, 1, ${animationDuration}, menu_decel"
        "fadeLayersOut, 1, ${animationDuration}, menu_accel"
        "workspaces, 1, ${animationDuration}, menu_decel, slide"
        "specialWorkspace, 1, ${animationDuration}, md3_decel, slidevert"
      ];
    };
  };
}
