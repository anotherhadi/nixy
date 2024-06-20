{ pkgs, ... }: {
  services.nginx.virtualHosts."home.anotherhadi.com" = {
    enableACME = true;
    root = pkgs.buildNpmPackage {
      pname = "homepage";
      version = "0.0.0";

      src = pkgs.fetchFromGitHub {
        owner = "anotherhadi";
        repo = "homepage";
        rev = "6588787368cbc403cdec08fd25ef27b42077b8d3";
        hash = "sha256-Z2TZ56I6lRmYkLRnnMscvmSCzGt5q9yX90lGPebJpe8=";
      };

      npmDepsHash = "sha256-tuEfyePwlOy2/mOPdXbqJskO6IowvAP4DWg8xSZwbJw=";

      # The prepack script runs the build script, which we'd rather do in the build phase.
      npmPackFlags = [ "--ignore-scripts" ];

      NODE_OPTIONS = "--openssl-legacy-provider";

      meta = {
        description = "test";
        homepage = "https://text.com";
      };

    };
  };
}
