{
  config,
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
          add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' data: https://umami.${config.var.domain}; style-src 'self' 'unsafe-inline'; img-src 'self' data: https://git.${config.var.domain}; connect-src 'self' https://umami.${config.var.domain};" always;
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
          return 301 https://${config.var.domain}$request_uri;
        '';
      };
    };

    cloudflared.tunnels."${config.var.tunnelId}".ingress = {
      "${config.var.domain}" = "http://127.0.0.1:8758";
      "www.${config.var.domain}" = "http://127.0.0.1:8189";
    };
  };
}
