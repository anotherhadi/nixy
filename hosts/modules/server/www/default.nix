{

  imports = [ ./home.anotherhadi.com ];

  services.nginx.virtualHosts = {
    "anotherhadi.com" = {
      serverAliases = [ "www.anotherhadi.com" ];
      root = "/etc/www/anotherhadi.com";
    };
    "home.anotherhadi.com" = { root = "/etc/www/home.anotherhadi.com"; };
  };
  environment.etc."www/anotherhadi.com" = { source = ./home.anotherhadi.com; };
}
