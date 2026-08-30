# Hyprland is a dynamic tiling Wayland compositor.
{...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Generic Wayland hints (Chromium/Electron and Firefox), applied on every
  # Hyprland host regardless of the GPU.
  environment.variables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  security.pam.services.hyprlock = {};
}
