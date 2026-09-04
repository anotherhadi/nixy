{lib, ...}: let
  port = 8080;
in {
  options.services.signal-cli-rest-api.url = lib.mkOption {
    type = lib.types.str;
    readOnly = true;
    default = "http://127.0.0.1:${toString port}";
    description = "URL of the local signal-cli-rest-api instance.";
  };

  config = {
    virtualisation.docker.enable = true;

    systemd.tmpfiles.rules = ["d /var/lib/signal-cli-rest-api 0750 root root -"];

    virtualisation.oci-containers = {
      backend = "docker";
      containers.signal-cli-rest-api = {
        image = "bbernhard/signal-cli-rest-api:0.98";
        # json-rpc keeps one persistent signal-cli daemon instead of spawning
        # a fresh process per API call; native mode serializes calls behind a
        # file lock and each spawn takes ~40s, causing timeouts under any
        # concurrent access (e.g. Home Assistant retries).
        environment.MODE = "json-rpc";
        ports = ["127.0.0.1:${toString port}:8080"];
        volumes = ["/var/lib/signal-cli-rest-api:/home/.local/share/signal-cli"];
      };
    };
  };
}
