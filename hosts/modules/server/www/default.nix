{

  imports = [ ./home.anotherhadi.com ];

  services.nginx.virtualHosts = {
    "anotherhadi.com" = {
      # serverAliases = [ "www.anotherhadi.com" ];
      root = "/etc/www/anotherhadi.com";
    };
    "home.anotherhadi.com" = { root = "/etc/www/home.anotherhadi.com"; };
    "www.anotherhadi.com" = { root = "/var/www/test"; };
  };
  environment.etc."www/anotherhadi.com" = { source = ./anotherhadi.com; };
}
