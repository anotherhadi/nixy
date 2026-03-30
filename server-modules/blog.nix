{
  inputs,
  pkgs,
  ...
}: {
  services = {
    nginx.virtualHosts = {
      "blog.local" = {
        root = "${inputs.blog.packages.${pkgs.system}.default}/share/blog";
        listen = [
          {
            addr = "127.0.0.1";
            port = 8758;
          }
        ];
        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
        };
        extraConfig = ''
          port_in_redirect off;
          absolute_redirect off;
          add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' data: https://umami.hadi.icu; style-src 'self' 'unsafe-inline'; img-src 'self' data: https://git.hadi.icu; connect-src 'self' https://umami.hadi.icu;" always;
        '';
      };

      "www.blog.local" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 8189;
          }
        ];
        extraConfig = ''
          return 301 https://hadi.icu$request_uri;
        '';
      };
    };

    cloudflared.tunnels."a1dfa315-7fc3-4a65-8c02-8387932c35c3".ingress = {
      "hadi.icu" = "http://127.0.0.1:8758";
      "www.hadi.icu" = "http://127.0.0.1:8189";
    };
  };
}
