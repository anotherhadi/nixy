# *arr is a collection of media management applications.
# See https://github.com/rasmus-kirk/nixarr
# Setup guide: https://nixarr.com/wiki/setup/
{config, ...}: let
  domain = "hadi.diy";
  mkVirtualHost = port: {
    useACMEHost = domain;
    forceSSL = true;
    locations."/" = {proxyPass = "http://127.0.0.1:${toString port}";};
  };
  username = config.var.username;
in {
  # Add my secrets
  sops.secrets = {
    recyclarr = {
      owner = "recyclarr";
      mode = "0777";
    };
    wireguard-pia = {
      group = "media";
      mode = "0600";
    };
  };

  nixarr = {
    enable = true;

    mediaUsers = [username];
    mediaDir = "/mnt/data/media";
    stateDir = "/mnt/data/.state/nixarr";

    vpn = {
      enable = true;
      wgConf = config.sops.secrets.wireguard-pia.path;
    };

    jellyfin.enable = true;
    jellyseerr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    sonarr.enable = true;
    bazarr.enable = true;
    transmission = {
      enable = true;
      extraSettings = {trash-original-torrent-files = true;};
      vpn.enable = true;
    };
    recyclarr = {
      enable = true;
      configFile = config.sops.secrets.recyclarr.path;
    };
  };

  services.nginx.virtualHosts = {
    "jellyfin.${domain}" = mkVirtualHost 8096;
    "jellyseerr.${domain}" = mkVirtualHost 5055;
    "bazarr.${domain}" = mkVirtualHost 6767;
    "prowlarr.${domain}" = mkVirtualHost 9696;
    "radarr.${domain}" = mkVirtualHost 7878;
    "sonarr.${domain}" = mkVirtualHost 8989;
    "transmission.${domain}" = mkVirtualHost 9091;
  };
}
