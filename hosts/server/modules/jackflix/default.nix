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
  ];

  users = {
    groups.nixarr = { };
    users.nixarr = {
      isSystemUser = true;
      group = "nixarr";
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

    transmission = {
      enable = true;
      user = "nixarr";
      group = "nixarr";
      openFirewall = true;
      settings = {
        "rpc-bind-address" = "192.168.15.1"; # Bind RPC/WebUI to bridge address
      };
    };
  };

  # Define VPN network namespace
  vpnnamespaces.wg = {
    enable = true;
    wireguardConfigFile = "/data/.secret/wg.conf";
    accessibleFrom = [ "192.168.1.0/24" ];
    portMappings = [{
      from = 9091;
      to = 9091;
    }];
    openVPNPorts = [{
      port = 60729;
      protocol = "both";
    }];
  };

  # Add systemd service to VPN network namespace.
  systemd.services.transmission.vpnconfinement = {
    enable = true;
    vpnnamespace = "wg";
  };
}
