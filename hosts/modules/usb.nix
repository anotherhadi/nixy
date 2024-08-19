{ pkgs, config, ... }:

{
  # USB Automounting
  # services.gvfs.enable = true;
  services.udisks2.enable = true;
  # services.devmon.enable = true;

  # Enable USB Guard
  services.usbguard = {
    enable = config.var.usbguard;
    dbus.enable = true;
    implicitPolicyTarget = "block";
    rules = config.var.usbguardRules;
  };

  # Enable USB-specific packages
  environment.systemPackages = with pkgs; [ usbutils ];
}
