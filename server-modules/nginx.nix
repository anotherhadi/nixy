{ config, ... }: {
  services.nginx = { enable = true; };

  security.acme = {
    acceptTerms = true;
    defaults.email = config.var.git.email;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
