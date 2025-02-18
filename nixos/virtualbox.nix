{ config, ... }:
let username = config.var.username;
in {
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  users.extraGroups.vboxusers.members = [ username ];
}
