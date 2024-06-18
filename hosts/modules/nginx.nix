{
  services.nginx = {
    enable = true;
    virtualHosts = {
      "test.anotherhadi.com" = {
        locations."/" = {
          proxy_set_header = [
            "X-Real-IP $remote_addr"
            "proxy_set_header Host $host"
            "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for"
          ];
          proxyPass = "http://192.168.2.22:80";
        };
      };
    };
  };
}
