{ pkgs, lib, ... }:
let
  package = pkgs.buildNpmPackage {
    pname = "homepage";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "anotherhadi";
      repo = "portfolio";
      rev = "5d54a2d204cdbf0f702173c1bf1279bca25eb736";
      hash = "sha256-8vDm9YwZKpMujILZjXtRERUIxvDqddSxS/gdJfZdUdY=";
    };

    npmDepsHash = "sha256-KMILWgZ6GNKoe/+RZS1tVDTd3SxXl6YtOuCb5kSFeis=";

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
