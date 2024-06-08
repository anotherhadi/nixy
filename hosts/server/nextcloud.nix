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
    forceSSL = false;
    enableACME = false;
    listen = [{
      addr = "localhost";
      port = 8083;
    }];
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
      '';
    };
  };
}
