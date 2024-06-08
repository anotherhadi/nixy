{ pkgs, config, ... }: {

  environment.systemPackages = with pkgs; [ nextcloud29 ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "cloud.anotherhadi.com";
    config.adminpassFile = "/etc/nextcloudpwd";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 8083 ];

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
    listen = [{
      addr = "localhost";
      port = 8083;
    }];
  };
  security.acme = {
    defaults.email = "contact@anotherhadi.com";
    acceptTerms = true;
  };
}
