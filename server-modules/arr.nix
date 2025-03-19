{ config, ... }:
let
  domain = "hadi.diy";
  mkVirtualHost = name: port: {
    useACMEHost = domain;
    forceSSL = true;
    locations."/" = { proxyPass = "http://127.0.0.1:${toString port}"; };
  };
in {
  nixarr = {
    enable = true;
    vpn = {
      enable = true;
      wgConf = config.sops.secrets.wireguard-pia.path;
    };
    mediaDir = "/data/media";
    stateDir = "/data/.state/nixarr";

    jellyfin.enable = true;
    jellyseerr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;
    sabnzbd.enable = true;
    transmission = {
      enable = true;
      extraSettings = { trash-original-torrent-files = true; };
      vpn.enable = true;
    };

    recyclarr = {
      enable = true;
      configFile = config.sops.secrets.recyclarr.path;
    };
  };

  services.nginx.virtualHosts = {
    "jellyfin.${domain}" = mkVirtualHost "jellyfin" 8096;
    "jellyseerr.${domain}" = mkVirtualHost "jellyseerr" 5055;
    "prowlarr.${domain}" = mkVirtualHost "prowlarr" 9696;
    "radarr.${domain}" = mkVirtualHost "radarr" 7878;
    "sonarr.${domain}" = mkVirtualHost "sonarr" 8989;
    "sabnzbd.${domain}" = mkVirtualHost "sabnzbd" 8080;
    "transmission.${domain}" = mkVirtualHost "transmission" 9091;
  };
}
