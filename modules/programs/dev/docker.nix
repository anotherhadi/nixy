{
  flake.modules.nixos.docker = {
    config,
    pkgs,
    ...
  }: {
    virtualisation.docker.enable = true;
    users.users."${config.nixy.username}".extraGroups = ["docker"];
    environment.systemPackages = [pkgs.lazydocker];
  };
}
