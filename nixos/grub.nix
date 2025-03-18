{ pkgs, config, ... }: {
  stylix.targets.grub.enable = false;

  boot = {
    bootspec.enable = true;
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };

      grub2-theme = {
        enable = true;
        theme = "whitesur";
        icon = "whitesur";
        splashImage = config.stylix.image;
        bootMenuConfig = ''
          item_color = "#333333"
          selected_item_color = "#000000"
          left = 30%
          top = 30%
          width = 40%
          height = 40%
          item_font = "Unifont Regular 24"
          icon_width = 48
          icon_height = 48
          item_icon_space = 24
          item_height = 56
          item_padding = 8
          item_spacing = 16
          selected_item_pixmap_style = "select_*.png"
        '';
      };
    };

    tmp.cleanOnBoot = true;
    kernelPackages =
      pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.

    # Silent boot
    kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };
}
