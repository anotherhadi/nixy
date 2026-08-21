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
      allow id 17ef:6190 name "Lenovo Calliope USB Keyboard G2"
      allow id 17ef:608d name "Lenovo USB Optical Mouse"
    '';
  };
}
