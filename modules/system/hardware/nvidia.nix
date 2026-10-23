# Nvidia configuration for NixOS with Wayland support
# Import this module only if you have an Nvidia GPU
{
  flake.modules.nixos.nvidia = {
    pkgs,
    config,
    ...
  }: let
    nvidiaDriverChannel = config.boot.kernelPackages.nvidiaPackages.production;
  in {
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      nvidia = {
        open = true;
        nvidiaSettings = false;
        powerManagement = {
          enable = true;
          finegrained = true;
        };
        dynamicBoost.enable = true;
        modesetting.enable = true;
        package = nvidiaDriverChannel;

        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
        };
      };

      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [pkgs.nvidia-vaapi-driver];
      };
    };

    # Nix cache for CUDA
    nix.settings = {
      substituters = [
        "https://cache.nixos-cuda.org"
      ];
      trusted-public-keys = [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      ];
    };

    environment.systemPackages = with pkgs; [
      vulkan-tools
      mesa-demos
      libva-utils
    ];
  };
}
