# Mazanoke is a self-hosted image downgrader
{
  config,
  pkgs,
  ...
}: let
  version = "1.1.5";
  mazanoke-pkg = pkgs.stdenv.mkDerivation {
    inherit version;
    pname = "mazanoke";
    src = pkgs.fetchFromGitHub {
      owner = "civilblur";
      repo = "mazanoke";
      rev = "v${version}";
      hash = "sha256-B/AF4diMNxN94BzpZP/C+K8kNj9q+4SDKWa/qd4LrVU=";
    };

    installPhase = ''
      mkdir -p $out/share/mazanoke
      cp -r ./index.html ./favicon.ico ./manifest.json ./service-worker.js ./assets $out/share/mazanoke/
    '';
  };
in {
  services = {
    nginx.virtualHosts."mazanoke.local" = {
      root = "${mazanoke-pkg}/share/mazanoke";
      locations."/" = {
        index = "index.html";
      };
      listen = [
        {
          addr = "127.0.0.1";
          port = 8755;
        }
      ];
    };
    cloudflared.tunnels."${config.var.tunnelId}".ingress."mazanoke.${config.var.domain}" = "http://localhost:8755";
  };
}
