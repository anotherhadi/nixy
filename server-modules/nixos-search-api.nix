{ inputs, config, ... }:
let domain = "nixos-search-api.hadi.diy";
in {
  imports = [ inputs.nixos-search-api.nixosModules.nixos-search-api ];

  services.nixos-search-api = {
    enable = true;
    port = 8089;
  };

  nginx.virtualHosts."${domain}" = {
    useACMEHost = "hadi.diy";
    forceSSL = true;
    locations."/" = {
      proxyPass =
        "http://127.0.0.1:${toString config.services.nixos-search-api.port}";
    };
  };
}
