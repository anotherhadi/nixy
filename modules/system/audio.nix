# Audio configuration for NixOS using PipeWire
{
  flake.modules.nixos.audio = {pkgs, ...}: {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    security.rtkit.enable = true;

    environment.systemPackages = [pkgs.alsa-utils];

    # TODO: Desc
    services.udev.extraRules = ''
      SUBSYSTEM=="sound", KERNEL=="controlC*", ATTRS{idVendor}=="03f0", ATTRS{idProduct}=="056b", TAG+="systemd", ENV{SYSTEMD_WANTS}+="unmute-dock-headphones@%k.service"
    '';

    systemd.services."unmute-dock-headphones@" = {
      description = "Unmute Headphones on HP USB-C Dock G5 sound card %i";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.alsa-utils}/bin/amixer -c $(echo %i | sed s/controlC//) sset Headphones unmute'";
      };
    };
  };
}
