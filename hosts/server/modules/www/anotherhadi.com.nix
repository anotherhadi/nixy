{ pkgs, lib, ... }:
let
  package = pkgs.buildNpmPackage {
    pname = "homepage";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "anotherhadi";
      repo = "portfolio";
      rev = "3f03233f7dcc5fb175c8bba8874a2f5c26999c93";
      hash = "sha256-q8cRi3DEwM/9DUxKbeJMv/TULf/mR0pg16orkd3xMNo=";
    };

    npmDepsHash = lib.fakeHash;

    buildPhase = ''
      npm install
      npm run build
      mkdir $out
      mv build $out
    '';

    meta = {
      description = "portfolio";
      homepage = "https://github.com/anotherhadi/portfolio";
    };
  };

in {
  services.nginx.virtualHosts."anotherhadi.com" = {
    serverAliases = [ "www.anotherhadi.com" ];
    enableACME = true;
    root = package + "/build";
  };
}
