{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "test.anotherhadi.com" = {
        locations."/" = { proxyPass = "http://192.168.2.22"; };
      };
    };
  };
}
