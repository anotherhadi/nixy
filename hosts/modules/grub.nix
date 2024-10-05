{ pkgs, ... }: {
  boot = {
    loader.grub.enable = true;
    loader.grub.device = "nodev";
    loader.grub.useOSProber = true;
    loader.grub.efiSupport = true;
    loader.efi.canTouchEfiVariables = true;
    tmp.cleanOnBoot = true;
    kernelPackages =
      pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.
  };
}
