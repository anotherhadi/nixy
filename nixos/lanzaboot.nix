# Secure Boot via lanzaboote (signed systemd-boot + unified kernel images)
#
# One-time setup on the machine (not handled by Nix):
#   1. sudo sbctl create-keys
#   2. Reboot into firmware setup, put Secure Boot in "Setup Mode"
#   3. nixos-rebuild switch (this signs the current generation with the new keys)
#   4. sudo sbctl enroll-keys --microsoft
#   5. Reboot, re-enable Secure Boot in firmware
{
  pkgs,
  lib,
  ...
}: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = lib.mkForce false;
        consoleMode = "auto";
        configurationLimit = 8;
      };
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages; # _latest, _zen, _hardened, _rt, _rt_latest, etc.

    # Silent boot
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  environment.systemPackages = [pkgs.sbctl];

  # To avoid systemd services hanging on shutdown
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
  };

  environment.persistence."/persist".directories = [
    "/var/lib/sbctl"
  ];
}
