{ pkgs, lib, ... }:
let
  package = pkgs.buildNpmPackage {
    pname = "homepage";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "anotherhadi";
      repo = "portfolio";
      rev = "48effd644da4d89921a4c1a3f5f6f5b6bd09eb6d";
      hash = "sha256-cFoq957oKS2MbKm94sUwAbS6GZ+IYWslZmvqyvK25m0=";
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
