{pkgs, ...}: {
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      libvdpau-va-gl
      libva-vdpau-driver
    ];
  };
}
