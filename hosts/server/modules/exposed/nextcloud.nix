# Nextcloud
{ config, ... }:
let hostname = "cloud.anotherhadi.com";
in {
  services.nextcloud = {
    enable = true;
    hostName = hostname;
    https = true;
    config = {
      adminuser = "jack";
      adminpassFile = "/etc/nextcloud/adminpassFile";
    };
    settings = {
      trusted_domains =
        [ "localhost" "127.0.0.1" "192.168.1.99" "cloud.anotherhadi.com" ];
    };
    nginx.recommendedHttpHeaders = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)
        contacts calendar tasks notes;
    };
    extraAppsEnable = true;
  };
  services.nginx.virtualHosts.${hostname} = {
    forceSSL = false;
    enableACME = true;
  };
}
