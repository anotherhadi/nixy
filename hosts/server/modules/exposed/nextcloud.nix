# Nextcloud
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
        [ "localhost" "127.0.0.1" "192.168.2.23" "cloud.anotherhadi.com" ];
    };
    nginx.recommendedHttpHeaders = true;
  };
  services.nginx.virtualHosts.${hostname} = {
    forceSSL = false;
    enableACME = true;
  };
}