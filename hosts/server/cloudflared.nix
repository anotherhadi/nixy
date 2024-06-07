{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "55ac0504-4ba0-4ea7-bf38-6d04ca7e45c3" = {
        credentialsFile = "/etc/cloudflaredpwd";
        default = "http_status:404";
        ingress = {
          "cloud.anotherhadi.com" = { service = "http://localhost:8080"; };
        };
      };
    };
  };
}
