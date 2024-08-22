{
  imports = [ ./home.anotherhadi.com.nix ./anotherhadi.com.nix ];

  services.nginx.virtualHosts = {
    # "test.anotherhadi.com" = { root = "/var/www/test"; };
  };
}
