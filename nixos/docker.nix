{config, pkgs, ...}: {
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;
  users.users."${config.var.username}".extraGroups = ["docker"];
}
