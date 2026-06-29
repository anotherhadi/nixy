# Hyprland is a dynamic tiling Wayland compositor.
{...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  security.pam.services.hyprlock = {};
}
