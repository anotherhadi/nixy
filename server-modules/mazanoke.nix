# Mazanoke is a self-hosted image downgrader
{pkgs, ...}: let
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
    cloudflared.tunnels."f7c8f777-a36c-4b9a-b6e3-6a112bd43e73".ingress."mazanoke.hadi.diy" = "http://localhost:8755";
  };
}
