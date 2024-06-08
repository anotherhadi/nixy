{ pkgs, config, ... }: {

  environment.systemPackages = with pkgs; [ nextcloud29 ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "cloud.anotherhadi.com";
    config.adminpassFile = "/etc/nextcloudpwd";
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = false;
    enableACME = false;
  };
}
