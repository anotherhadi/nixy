# Systemd-boot configuration for NixOS
{aspects, ...}: {
  flake.modules.nixos.systemd-boot = {
    imports = [aspects.boot];

    boot.loader.systemd-boot.enable = true;
  };
}
