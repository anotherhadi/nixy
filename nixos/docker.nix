# Docker is a containerization platform that allows you to run applications in isolated environments called containers.
{config, ...}: {
  virtualisation.docker.enable = true;
  users.users."${config.var.username}".extraGroups = ["docker"];
}
