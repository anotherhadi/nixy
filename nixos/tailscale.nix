{ config, ... }: {
  security.sudo.extraRules = [{
    users = [ config.var.username ];
    commands = [
      {
        command = "/etc/profiles/per-user/${config.var.username}/bin/tailscale";
        options = [ "NOPASSWD" ];
      }
      {
        command = "/run/current-system/sw/bin/tailscale";
        options = [ "NOPASSWD" ];
      }
    ];
  }];
  services.tailscale = { enable = true; };
}
