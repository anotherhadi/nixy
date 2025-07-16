{config, ...}: {
  virtualisation.docker.enable = true;
  users.users."${config.var.username}".extraGroups = ["docker"];
}
