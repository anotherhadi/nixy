# Bluetooth configuration for NixOS
{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
    };

    environment.persistence."/persist".directories = ["/var/lib/bluetooth"]; # Paired devices
  };
}
