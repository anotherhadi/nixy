{ pkgs, lib, ... }:
let
  package = pkgs.buildNpmPackage {
    pname = "homepage";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "anotherhadi";
      repo = "portfolio";
      rev = "2ae002e2393d5a29c0383ac51dfd32d7f423b1d3";
      hash = "sha256-welRtqX5KXslhww7yRHtGPxCv8mCwcU/JhDrFGNr8ZE=";
    };

    npmDepsHash = "sha256-+CWPoDhTRxQaE83svj9Ms24lLpbwl4HqSOd2mUw99j4=";

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
