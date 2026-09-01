# USBGuard:
# The following line allow all USB devices until a proper policy is configured.
# Run `sudo usbguard generate-policy` with your devices plugged in,
# then set rules = "<output>" and switch implicitPolicyTarget to "block".
# services.usbguard.implicitPolicyTarget = lib.mkForce "allow";
{
  services.usbguard = {
    enable = true;
    implicitPolicyTarget = "block";
    IPCAllowedUsers = [
      "root"
    ];
    rules = ''
      allow id 1d6b:0002 name "xHCI Host Controller"
      allow id 1d6b:0003 name "xHCI Host Controller"
      allow id 8086:0b63 name "USB Bridge"
      allow id 27c6:63bc serial "UIDE0267113_XXXX_MOC_B0" name "Goodix Fingerprint USB Device"
    '';
  };
}
