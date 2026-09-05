# Audio configuration for NixOS using PipeWire
{pkgs, ...}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;

  environment.systemPackages = [pkgs.alsa-utils];

  # Fix for the HP USB-C Dock G5's
  services.udev.extraRules = ''
    SUBSYSTEM=="sound", KERNEL=="controlC*", ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="056b", RUN+="${pkgs.bash}/bin/bash -c '${pkgs.alsa-utils}/bin/amixer -c $(echo %k | sed s/controlC//) sset Headphones unmute'"
  '';
}
