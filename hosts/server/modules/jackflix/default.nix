{ config, ... }: {
  nixarr = {
    enable = true;
    mediaDir = "/data/media";
    stateDir = "/data/media/.state/nixarr";

    vpn = {
      enable = true;
      wgConf = "/data/.secret/wg.conf";
    };

    jellyfin = {
      enable = true;
      expose.https = {
        enable = true;
        domainName = "media.anotherhadi.com";
        acmeMail = config.var.git.email; # Required for ACME-bot
      };
    };

    transmission = {
      enable = true;
      vpn.enable = true;
      peerPort = 50000;
    };

    bazarr.enable = true;
    lidarr.enable = true;
    prowlarr.enable = true;
    radarr.enable = true;
    readarr.enable = true;
    sonarr.enable = true;
  };
}
