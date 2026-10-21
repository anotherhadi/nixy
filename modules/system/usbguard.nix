# USBGuard: block USB devices that aren't explicitly allowed
# Hosts set their own rules (services.usbguard.rules), they depend on the hardware:
#   run `sudo usbguard generate-policy` with your devices plugged in and paste the output.
# Until a policy is configured, allow everything from the host with
#   services.usbguard.implicitPolicyTarget = lib.mkForce "allow";
{
  flake.modules.nixos.usbguard = {
    services.usbguard = {
      enable = true;
      implicitPolicyTarget = "block";
      IPCAllowedUsers = ["root"];
    };
  };
}
