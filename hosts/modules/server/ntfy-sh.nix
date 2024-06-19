# Push Notification Server
# https://mynixos.com/nixpkgs/options/services.ntfy-sh
let
  hostname = "ntfy.anotherhadi.com";
  port = 8082;
  url = "https://" + hostname + ":${toString port}";
in {
  services.ntfy-sh = {
    enable = true;
    settings = {
      base-url = url;
      listen-http = "${toString port}";
      # auth-file = "/etc/ntfy-sh/authfile"
      auth-default-access = "deny-all";
      behind-proxy = true;
    };
  };
  services.nginx.virtualHosts.${hostname} = {
    enableACME = true;
    locations."/" = { proxyPass = "http://127.0.0.1:${toString port}"; };
  };
  networking.firewall.allowedTCPPorts = [ port ];
}
