{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "homepage";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "anotherhadi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BR+ZGkBBfd0dSQqAvujsbgsEPFYw/ThrylxUbOksYxM=";
  };

  npmDepsHash = "sha256-tuEfyePwlOy2/mOPdXbqJskO6IowvAP4DWg8xSZwbJw=";

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];

  meta = {
    description = "A simple homepage for your server.";
    homepage = "https://github.com/anotherhadi/homepage";
    # license = lib.licenses.gpl3Only;
    # maintainers = with lib.maintainers; [ winter ];
  };
}
