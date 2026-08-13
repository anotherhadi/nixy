{
  config,
  pkgs,
  ...
}: {
  virtualisation.docker.enable = true;
  users.users."${config.var.username}".extraGroups = ["docker"];
  environment.systemPackages = [pkgs.lazydocker];
}
