{
  config,
  inputs,
  lib,
  ...
}: let
  inherit (import ./mk-container.nix {inherit lib config;}) mkContainer;
  domain = config.var.domain;
in {
  imports = [
    (mkContainer {
      name = "blog";
      hostIp = "10.233.3.1";
      containerIp = "10.233.3.2";
      nixosConfig = {pkgs, ...}: {
        services.nginx = {
          enable = true;
          virtualHosts = {
            "blog" = {
              root = "${inputs.blog.packages.${pkgs.system}.default}/share/blog";
              listen = [
                {
                  addr = "0.0.0.0";
                  port = 8080;
                }
              ];
              locations."/" = {
                tryFiles = "$uri $uri/ =404";
              };
              extraConfig = ''
                port_in_redirect off;
                absolute_redirect off;
                error_page 403 /403.html;
                error_page 404 /404.html;
                error_page 500 /500.html;
                error_page 503 /503.html;
                add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' data: https://umami.${domain}; style-src 'self' 'unsafe-inline'; img-src 'self' data: https://git.${domain}; connect-src 'self' https://umami.${domain};" always;
                add_header X-Frame-Options "SAMEORIGIN" always;
                add_header X-Content-Type-Options "nosniff" always;
                add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
              '';
            };
            "www-redirect" = {
              listen = [
                {
                  addr = "0.0.0.0";
                  port = 8081;
                }
              ];
              extraConfig = "return 301 https://${domain}$request_uri;";
            };
          };
        };
        networking.firewall.allowedTCPPorts = [
          8080
          8081
        ];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress = {
    "${config.var.domain}" = "http://10.233.3.2:8080";
    "www.${config.var.domain}" = "http://10.233.3.2:8081";
  };
}
