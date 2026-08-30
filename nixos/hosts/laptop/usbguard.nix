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
      allow id 13fd:5900 name "External"
      allow id 1d6b:0003 name "xHCI Host Controller"
      allow id 1d6b:0002 name "xHCI Host Controller"
      allow id 0bda:c85c name "Bluetooth Radio"
      allow id 30c9:009f name "HP True Vision FHD Camera"
      allow id 03f0:036b name "HP USB-C Dock G5"
      allow id 03f0:066b name "HP USB-C Dock G5"
      allow id 03f0:056b name "USB Audio"
      allow id 0bda:8153 name "USB 10/100/1000 LAN"
      allow id 046d:0ab7 name "Blue Microphones"
      allow id 03f0:076b name "USB5734"
      allow id 1532:02a1 name "Razer Ornata V3"
      allow id 03f0:046b name "HP USB-C Dock G5"
      allow id 03f0:086b name "USB2734"
    '';
  };
}
