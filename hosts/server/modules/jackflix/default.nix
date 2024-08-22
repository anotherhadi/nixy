let
  exposed = false; # Expose jellyfin to the internet

  vpn = {
    enable = true;
    wg-config = "/etc/wireguard/wg0.conf";
  };

  root_folder = "/data";
in {
  systemd.tmpfiles.rules = [
    "d /data 0755 nixarr nixarr"
    "d /data/media 0755 nixarr nixarr"
    "d /data/radarr 0755 nixarr nixarr"
    "d /data/sonarr 0755 nixarr nixarr"
  ];

  users = {
    groups.nixarr = { };
    users.nixarr = {
      isSystemUser = true;
      home = root_folder;
      hashedPassword =
        "$y$j9T$9.hOJCwwmryq3PzEOGtjZ.$hu/76TghEjongcbls7oDoN2GWRqg8AwCknq.CS0zB.8";
    };
  };

  services = {
    jellyfin = {
      enable = true;
      user = "jackflix";
      group = "media";
      openFirewall = true;
    };

    jellyseerr = {
      enable = true;
      port = 5055;
      openFirewall = true;
    };

    prowlarr = {
      enable = true;
      openFirewall = true;
    };

    radarr = {
      enable = true;
      user = "jackflix";
      group = "media";
      dataDir = "/data/media/radarr";
      openFirewall = true;
    };

    sonarr = {
      enable = true;
      user = "jackflix";
      group = "media";
      dataDir = "/data/media/sonarr";
      openFirewall = true;
    };

    transmission = {
      enable = true;
      user = "jackflix";
      group = "media";
      openFirewall = true;
    };
  };
}
