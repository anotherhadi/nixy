{ config, ... }: {
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
    openFirewall = true;
    ports = [ 22 ];
    settings.AllowUsers = [ config.var.username ];
  };

  users.users."${config.var.username}" = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPG9SE80ZyBcXZK/f5ypSKudaM5Jo3XtQikCnGo0jI5E hadi@nixy"
    ];
  };
}
