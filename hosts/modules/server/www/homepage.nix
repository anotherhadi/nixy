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

      npmDepsHash = "sha256-YxdrNTBbbgMHJ0WoSHePxdM7UJLbKsSbObW8M1uArUg=";

      buildPhase = ''
        npm install
        npm run build

        mkdir $out
        mv build $out
      '';

      meta = {
        description = "test";
        homepage = "https://text.com";
      } + "/build";
    };

  };
}
