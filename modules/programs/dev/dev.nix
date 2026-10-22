# Development tools
{aspects, ...}: {
  flake.modules.nixos.dev = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: {
        packages =
          (with pkgs.unstable; [
            go
            bun
            nodejs
          ])
          ++ (with pkgs; [
            air
            duckdb
            python3
            jq
            yq-go
            nix-prefetch-github
            rsync
          ]);

        environment.sessionVariables = {
          GOPATH = "$HOME/.local/share/go";
          PATH = ["$HOME/.local/share/go/bin" "$PATH"];
        };

        persist.files = [".npmrc"]; # npm login token
      })
    ];
  };
}
