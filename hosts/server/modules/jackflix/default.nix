{
  imports = [
    # ./jellyfin.nix
    # ./jellyseerr.nix
    # ./prowlarr.nix
    # ./radarr.nix
    # ./sonarr.nix
    # ./transmission.nix
  ];

  users.groups = { jackflix = { }; };

  users.users.jackflix = {
    isNormalUser = true;
    home = "/home/jackflix";
    description = "My own netflix";
    hashedPassword =
      "$y$j9T$9.hOJCwwmryq3PzEOGtjZ.$hu/76TghEjongcbls7oDoN2GWRqg8AwCknq.CS0zB.8";
    extraGroups = [ "docker" "jackflix" ];
  };
}
