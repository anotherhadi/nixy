# { pkgs, ... }: {
#   environment.systemPackages = with pkgs; [ cloudflared ];
#   services.cloudflared = {
#     enable = true;
#     tunnels = {
#       "55ac0504-4ba0-4ea7-bf38-6d04ca7e45c3" = {
#         credentialsFile = "/etc/cloudflaredpwd";
#         default = "http_status:404";
#         ingress = { };
#       };
#     };
#   };
# }
#
{ config, pkgs, ... }:

{
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    https = false;
    config = {
      dbtype = "sqlite";
      adminuser = "admin";
      adminpass = "TESTADMINPASSWORD";
      datadirectory = "/var/lib/nextcloud/data";
    };
  };

  services.postgresql.enable = true;

  services.nginx = {
    virtualHosts."localhost" = {
      forceSSL = true;
      enableACME = false;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080";
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  };
}
