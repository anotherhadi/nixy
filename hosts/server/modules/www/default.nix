{
  imports = [
    ./home.anotherhadi.com.nix
    ./start.anotherhadi.com.nix
    ./anotherhadi.com.nix
  ];

  services.nginx.virtualHosts = {
    "anotherhadi.com" = {
      serverAliases = [ "www.anotherhadi.com" ];
      root = "/etc/www/anotherhadi.com";
    };
    "test.anotherhadi.com" = { root = "/var/www/test"; };
  };
  environment.etc."www/anotherhadi.com" = { source = ./anotherhadi.com; };
}
