{ config, ... }:
let domain = "hoarder.hadi.diy";
in {
  systemd.tmpfiles.rules = [ 
    "d /var/lib/hoarder/web 0755 root root -" 
    "d /var/lib/hoarder/meili 0755 root root -" 
  ];

  virtualisation.oci-containers.containers = {
    hoarder-web = {
      environmentFiles = [ config.sops.secrets.hoarder.path ];
      image = "ghcr.io/hoarder-app/hoarder:release";
      volumes = [ "/var/lib/hoarder/web:/data" ];
      ports = [ "127.0.0.1:3131:3000" ];
      environment = {
        HOARDER_VERSION = "release";
        NEXTAUTH_URL = "https://" + domain;
        DATA_DIR = "/data";
        MEILI_ADDR = "http://hoarder-meili:7700";
        BROWSER_WEB_URL = "http://hoarder-browser:9222";
        DISABLE_SIGNUPS = "false";
      };
    };

    hoarder-meili = {
      environmentFiles = [ config.sops.secrets.hoarder.path ];
      image = "getmeili/meilisearch:v1.11.1";
      environment = { MEILI_NO_ANALYTICS = "true"; };
      volumes = [ "/var/lib/hoarder/meili:/meili_data" ];
    };

    hoarder-browser = {
      image = "gcr.io/zenika-hub/alpine-chrome:123";
      #pull = "newer";
      cmd = [
        "--no-sandbox"
        "--disable-gpu"
        "--disable-dev-shm-usage"
        "--remote-debugging-address=0.0.0.0"
        "--remote-debugging-port=9222"
        "--hide-scrollbars"
      ];
    };
  };
  services.nginx.virtualHosts."${domain}" = {
    useACMEHost = "hadi.diy";
    forceSSL = true;
    locations."/" = { proxyPass = "http://127.0.0.1:3131"; };
  };
}
