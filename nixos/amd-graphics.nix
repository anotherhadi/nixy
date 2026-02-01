{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      # Support VA-API pour AMD
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };
}
