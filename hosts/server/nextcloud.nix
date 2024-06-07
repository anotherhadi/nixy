{ pkgs, config, ... }: {

  environment.systemPackages = with pkgs; [ nextcloud29 ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud29;
    hostName = "localhost";
    config.adminpassFile = "/etc/nextcloudpwd";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 8080 ];

  services.nginx.virtualHosts."localhost".listen = [{
    addr = "127.0.0.1";
    port = 8080;
  }];
}
