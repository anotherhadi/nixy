{
  imports = [
    ./jellyfin.nix
    ./jellyseerr.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sonarr.nix
    ./transmission.nix
  ];

  users.users.jackflix = {
    isNormalUser = true;
    home = "/home/jackflix";
    description = "My own netflix";
    extraGroups = [ "docker" ];
  };
}
