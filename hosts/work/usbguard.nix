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
      allow id 0951:1666 name "DataTraveler 3.0"
      allow id 1d6b:0003 name "xHCI Host Controller"
      allow id 0461:574a name "HP 125 USB Optical Mouse"
      allow id 0461:554a name "HP 125 Wired Keyboard"
    '';
  };
}
