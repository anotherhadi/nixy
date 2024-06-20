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

      npmBuildScript = "run build";
      npmDepsHash = "sha256-YxdrNTBbbgMHJ0WoSHePxdM7UJLbKsSbObW8M1uArUg=";

      # The prepack script runs the build script, which we'd rather do in the build phase.
      npmPackFlags = [ "--ignore-scripts" ];

      NODE_OPTIONS = "--openssl-legacy-provider";

      meta = {
        description = "test";
        homepage = "https://text.com";
      };
    } + "/build";
  };
}
