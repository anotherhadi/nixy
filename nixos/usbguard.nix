{config, ...}: {
  services.usbguard = {
    enable = true;
    implicitPolicyTarget = "block";
    IPCAllowedUsers = [
      "root"
      config.var.username
    ];
  };
}
