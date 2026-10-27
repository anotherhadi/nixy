# Boot settings shared by both boot loaders
# kernel, silent boot, faster shutdown
{
  flake.modules.nixos.boot = {
    pkgs,
    lib,
    ...
  }: {
    boot = {
      loader = {
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          consoleMode = "auto";
          configurationLimit = 8;
          editor = false;
        };
      };

      tmp.cleanOnBoot = true;
      kernelPackages = lib.mkDefault pkgs.linuxPackages; # _latest, _zen, _hardened, _rt, _rt_latest, etc.

      # Silent boot
      kernelParams = [
        "quiet"
        "splash"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
      consoleLogLevel = 0;
      initrd.verbose = false;
    };

    # To avoid systemd services hanging on shutdown
    systemd.settings.Manager = {
      DefaultTimeoutStopSec = "10s";
    };
  };
}
