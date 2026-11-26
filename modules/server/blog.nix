# Personal website (https://github.com/anotherhadi/blog)
{
  inputs,
  config,
  ...
}: let
  inherit (config.flake.lib) mkContainer;
in {
  flake.modules.nixos.blog = {
    config,
    pkgs,
    ...
  }: let
    src = inputs.blog;

    nodeModules = pkgs.stdenvNoCC.mkDerivation {
      pname = "blog-node-modules";
      version = src.shortRev or "dirty";
      inherit src;
      nativeBuildInputs = [pkgs.bun];
      dontConfigure = true;
      dontFixup = true;
      impureEnvVars = pkgs.lib.fetchers.proxyImpureEnvVars;
      buildPhase = ''
        export HOME=$TMPDIR
        bun install --frozen-lockfile --no-progress --ignore-scripts
      '';
      installPhase = ''
        mkdir -p $out
        cp -r node_modules $out/
      '';
      outputHashMode = "recursive";
      outputHashAlgo = "sha256";
      outputHash = "sha256-Hf5YB2Ts2BmgUv93J/HIiNFP/69eZz2o9k8UL0+oNxk=";
    };

    site = pkgs.stdenvNoCC.mkDerivation {
      pname = "blog";
      version = src.shortRev or "dirty";
      inherit src;
      nativeBuildInputs = [pkgs.bun pkgs.nodejs];
      buildPhase = ''
        export HOME=$TMPDIR ASTRO_TELEMETRY_DISABLED=1
        cp -r ${nodeModules}/node_modules .
        chmod -R u+w node_modules
        patchShebangs node_modules
        bun run build
      '';
      installPhase = "cp -r dist $out";
    };
  in {
    imports = [
      (mkContainer config {
        name = "blog";
        hostIp = "10.233.17.1";
        containerIp = "10.233.17.2";
        nixosConfig = {...}: {
          services.nginx = {
            enable = true;
            virtualHosts."blog" = {
              root = "${site}";
              listen = [
                {
                  addr = "0.0.0.0";
                  port = 8080;
                }
              ];
            };
          };
          networking.firewall.allowedTCPPorts = [8080];
          system.stateVersion = "24.05";
        };
      })
    ];

    nixy.server.proxies.www = "http://10.233.17.2:8080";
    nixy.server.rootProxy = "http://10.233.17.2:8080";
  };
}
