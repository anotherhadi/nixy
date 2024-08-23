let
  exposed = false; # Expose jellyfin to the internet

  vpn = {
    enable = true;
    wg-config = "/etc/wireguard/wg0.conf";
  };

  root_folder = "/data";
in {
  systemd.tmpfiles.rules = [
    "d ${root_folder} 0755 nixarr nixarr"
    "d ${root_folder}/media 0755 nixarr nixarr"
    "d ${root_folder}/media/shows 0755 nixarr nixarr"
    "d ${root_folder}/media/movies 0755 nixarr nixarr"
    "d ${root_folder}/radarr 0755 nixarr nixarr"
    "d ${root_folder}/sonarr 0755 nixarr nixarr"
    "d ${root_folder}/jellyfin 0755 nixarr nixarr"
    "d ${root_folder}/transmission-openvpn/data 0755 nixarr nixarr"
    "d ${root_folder}/transmission-openvpn/data/completed 0755 nixarr nixarr"
    "d ${root_folder}/transmission-openvpn/data/incompleted 0755 nixarr nixarr"
  ];

  users = {
    groups.nixarr = { };
    users.nixarr = {
      isNormalUser = true;
      group = "nixarr";
      extraGroups = [ "docker" ];
      hashedPassword =
        "$y$j9T$9.hOJCwwmryq3PzEOGtjZ.$hu/76TghEjongcbls7oDoN2GWRqg8AwCknq.CS0zB.8";
    };
  };

  systemd.services.jellyfin.serviceConfig.IOSchedulingPriority = 0;

  services = {
    jellyfin = {
      enable = true;
      user = "nixarr";
      group = "nixarr";
      openFirewall = true;
      dataDir = "${root_folder}/jellyfin";
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
      user = "nixarr";
      group = "nixarr";
      dataDir = "${root_folder}/radarr";
      openFirewall = true;
    };

    sonarr = {
      enable = true;
      user = "nixarr";
      group = "nixarr";
      dataDir = "${root_folder}/sonarr";
      openFirewall = true;
    };
  };

  # Transmission port
  networking.firewall.allowedTCPPorts = [ 9091 ];
}
