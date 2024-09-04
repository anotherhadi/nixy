{ inputs, pkgs, ... }: {
  services.nginx.virtualHosts."anotherhadi.com" = {
    serverAliases = [ "www.anotherhadi.com" ];
    enableACME = true;
    root = inputs.anotherhadi-portfolio.packages."${pkgs.system}";
  };
}
