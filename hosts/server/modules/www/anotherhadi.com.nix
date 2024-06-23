{ pkgs, lib, ... }:
let
  package = pkgs.buildNpmPackage {
    pname = "homepage";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "anotherhadi";
      repo = "portfolio";
      rev = "1f30ea5d02f7a3831c7f3b2565c3bbfdddaac26e";
      hash = "sha256-fNt4IjfjhDtSEIC1MNWYkTIcHv+XnXFZTlw/dLoWhcY=";
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
