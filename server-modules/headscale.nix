{ config, pkgs, ... }:
let
  derpPort = 3478;
  domain = "hadi.diy";
  headscale-ui-src = pkgs.fetchFromGitHub {
    owner = "gurucomputing";
    repo = "headscale-ui";
    rev = "63041fd673d81da56e60d2b528a4991981eab746";
    sha256 = "pz7oDRfBf/dN+PMEqbMe+es6deQ4QP3pC191ASlyV7U=";
  };
  headscale-ui = pkgs.buildNpmPackage {
    pname = "headscale-ui";
    version = "0.0.1";
    src = headscale-ui-src;
    npmDepsHash = "MePNbOPSe5wB8/6T3DLs+4+Qlr8f+7cCPs301il7iX8=";
    buildPhase = ''
      runHook preBuild
      mkdir -p $out
      npm run build
      runHook postBuild
    '';
    installPhase = ''
      mv ./build $out/dist
    '';
    makeCacheWritable = true;
    dontFixup = true;
    dontNpmBuild = true;
  };
in {
  services = {
    headscale = {
      enable = true;
      port = 8085;
      address = "127.0.0.1";
      settings = {
        dns = {
          override_local_dns = true;
          base_domain = "ts.${domain}";
          magic_dns = true;
          nameservers.global = [ "9.9.9.9" ];
          # extra_records = [{
          #   name = "merope.${domain}";
          #   type = "A";
          #   value = "100.77.0.5";
          # }];
        };
        server_url = "https://tailscale.${domain}";
        metrics_listen_addr = "127.0.0.1:8095";
        logtail = { enabled = false; };
        log = { level = "warn"; };
        ip_prefixes = [ "100.77.0.0/24" "fd7a:115c:a1e0:77::/64" ];
        derp.server = {
          enable = true;
          region_id = 999;
          stun_listen_addr = "0.0.0.0:${toString derpPort}";
        };
      };
    };

    nginx.virtualHosts = {
      "tailscale.${domain}" = {
        useACMEHost = "hadi.diy";
        forceSSL = true;
        locations = {
          "/" = {
            proxyPass =
              "http://localhost:${toString config.services.headscale.port}";
            proxyWebsockets = true;
          };
          "/metrics" = {
            proxyPass =
              "http://${config.services.headscale.settings.metrics_listen_addr}/metrics";
          };
          "/web" = {
            root = "${headscale-ui}/dist";
            index = "index.html";
            tryFiles = [ "$uri" "/index.html" ];
          };
        };
      };
    };
  };

  # Derp server
  networking.firewall.allowedUDPPorts = [ derpPort ];

  environment.systemPackages = [ config.services.headscale.package ];
}
