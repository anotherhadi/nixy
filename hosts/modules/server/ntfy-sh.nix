# https://mynixos.com/nixpkgs/options/services.ntfy-sh
let
    hostname = "ntfy.anotherhadi.com";
    url = "https://"+hostname;
    port = 8082;
in{
    services.ntfy-sh = {
        enable = true;
        settings = {
            base-url = url;
            listen-http = "${port}";
            # auth-file
            auth-default-access = "deny-all";
            behind-proxy = true;
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