{ lib, pkgs, config, ... }:
let
  nvidiaDriverChannel =
    config.boot.kernelPackages.nvidiaPackages.beta; # stable, latest, beta, etc.
in {
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers =
    [ "nvidia" "displayLink" ]; # or "nvidiaLegacy470 etc.
  boot.kernelParams =
    lib.optionals (lib.elem "nvidia" config.services.xserver.videoDrivers) [
      "nvidia-drm.modeset=1"
      "nvidia_drm.fbdev=1"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
  environment.variables = {
    # GBM_BACKEND = "nvidia-drm"; # If crash in firefox, remove this line
    LIBVA_DRIVER_NAME = "nvidia"; # hardware acceleration
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
  nixpkgs.config = {
    nvidia.acceptLicense = true;
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "cudatoolkit"
        "nvidia-persistenced"
        "nvidia-settings"
        "nvidia-x11"
      ];
  };
  hardware = {
    nvidia = {
      open = false;
      nvidiaSettings = true;
      powerManagement.enable =
        true; # This can cause sleep/suspend to fail and saves entire VRAM to /tmp/
      modesetting.enable = true;
      package = nvidiaDriverChannel;
    };
    graphics = {
      enable = true;
      package = nvidiaDriverChannel;
      enable32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
        mesa
        egl-wayland
      ];
    };
  };
}
