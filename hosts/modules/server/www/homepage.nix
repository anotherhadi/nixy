{ pkgs, ... }: {
  services.nginx.virtualHosts."home.anotherhadi.com" = {
    enableACME = true;
    root = pkgs.stdenv.mkDerivation {
      name = "homepage";

      src = pkgs.fetchFromGitHub {
        owner = "anotherhadi";
        repo = "homepage";
        rev = "6588787368cbc403cdec08fd25ef27b42077b8d3";
        hash = "sha256-Z2TZ56I6lRmYkLRnnMscvmSCzGt5q9yX90lGPebJpe8=";
      };

      buildInputs = with pkgs; [ nodejs ];

      buildPhase = ''
        npm install
        npm run build
      '';

      installPhase = ''
        mkdir -p $out
        cp -r build/* $out
      '';

    };
  };
}
