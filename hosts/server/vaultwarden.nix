let
  port = 8222;
  signup = false;
in {
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://bw.anotherhadi.com";
      SIGNUPS_ALLOWED = signup;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = port;
      ROCKET_LOG = "critical";
    };
  };

  services.nginx.virtualHosts."bw.anotherhadi.com" = {
    locations."/" = { proxyPass = "http://127.0.0.1:${toString port}"; };
  };

  networking.firewall.allowedTCPPorts = [ port ];
}
