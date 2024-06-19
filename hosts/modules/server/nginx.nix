# Nginx Reverse Proxy & ACME certs
{ config, ... }: {
  services.nginx.enable = true;
  security.acme = {
    acceptTerms = true;
    defaults.email = config.var.git.email;
  };
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  # test
  services.nginx.virtualHosts."anotherhadi.com" = {
    serverAliases = [ "www.anotherhadi.com" ];
    root = "/var/www/default";
  };
}
