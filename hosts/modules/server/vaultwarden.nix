# Password manager
let
    hostname = "vault.anotherhadi.com";
    url = "https://"+hostname;
    port = 8222;
in{
    services.vaultwarden = {
        enable = true;
        config = {
            DOMAIN = url;
            SIGNUPS_ALLOWED = false;
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = port;
            ROCKET_LOG = "critical";
        };
    };
    services.nginx.virtualHosts.${hostname} = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
            proxyPass = "http://127.0.0.1:${port}";
        };
    };
  networking.firewall.allowedTCPPorts = [ port ];
}