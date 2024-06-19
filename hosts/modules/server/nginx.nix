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
    root = "/etc/www/home";
  };

  environment.etc = {
    "www/home" = {
      text = ''
        <html>
          <head>
            <title>Another Hadi</title>
          </head>
          <body>
            <h1>Another Hadi</h1>
          </body>
        </html>
      '';
    };
  };
}
