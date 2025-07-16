# Nginx is a web server that can also be used as a reverse proxy, load balancer, and HTTP cache.
{config, ...}: let
  domain = "hadi.diy";
in {
  security.acme = {
    acceptTerms = true;
    defaults.email = config.var.git.email;
    certs."${domain}" = {
      domain = "${domain}";
      extraDomainNames = ["*.${domain}"];
      group = "nginx";
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialsFile = config.sops.secrets.cloudflare-dns-token.path;
    };
  };

  # Return 444 for all requests not matching a used subdomain.
  services.nginx = {
    enable = true;
    virtualHosts = {
      "default" = {
        default = true;
        locations."/" = {return = 444;};
      };
      "*.${domain}" = {
        useACMEHost = domain;
        forceSSL = true;
        locations."/" = {return = 444;};
      };
      "aaaaaa.${domain}" = {
        useACMEHost = domain;
        forceSSL = true;
        locations."/" = {return = 444;};
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [80 443];
    allowedUDPPorts = [80 443];
  };

  sops.secrets.cloudflare-dns-token = {path = "/etc/cloudflare/dnskey.txt";};
}
