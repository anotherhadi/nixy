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
  };
}
