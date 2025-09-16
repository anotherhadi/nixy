{config, ...}: {
  services.eleakxir = {
    enable = true;
    port = 9198;
    folders = ["/var/lib/eleakxir/leaks/"];
    debug = true;
  };

  nginx.virtualHosts."eleakxir.hadi.diy" = {
    useACMEHost = "hadi.diy";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${
        toString config.services.eleakxir.port
      }";
    };
  };
}
