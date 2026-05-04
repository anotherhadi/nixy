{
  config,
  lib,
  ...
}: let
  inherit (import ./mk-container.nix {inherit lib config;}) mkContainer;
in {
  imports = [
    (mkContainer {
      name = "mazanoke";
      hostIp = "10.233.7.1";
      containerIp = "10.233.7.2";
      nixosConfig = {pkgs, ...}: let
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
        services.nginx = {
          enable = true;
          virtualHosts."mazanoke" = {
            root = "${mazanoke-pkg}/share/mazanoke";
            listen = [
              {
                addr = "0.0.0.0";
                port = 8080;
              }
            ];
            locations."/" = {
              index = "index.html";
            };
          };
        };
        networking.firewall.allowedTCPPorts = [8080];
        system.stateVersion = "24.05";
      };
    })
  ];

  services.cloudflared.tunnels."${config.var.tunnelId}".ingress."mazanoke.${config.var.domain}" = "http://10.233.7.2:8080";
}
