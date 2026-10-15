# Firewall configuration for NixOS
{
  flake.modules.nixos.firewall = {
    networking.firewall = {
      enable = true;
      allowPing = false;
    };
  };
}
