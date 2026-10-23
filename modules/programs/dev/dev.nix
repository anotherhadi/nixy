# Development tools
{aspects, ...}: {
  flake.modules.nixos.dev = {
    imports = [aspects.hjem];

    hjem.extraModules = [
      ({pkgs, ...}: {
        packages =
          (with pkgs.unstable; [
            bun
            nodejs
          ])
          ++ (with pkgs; [
            go
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
          GOPROXY = "direct"; # Fetch modules from their repo, not Google's proxy.golang.org
          DO_NOT_TRACK = "1"; # Bun crash reports, and every tool honoring it
          PATH = ["$HOME/.local/share/go/bin" "$PATH"];
        };

        persist.files = [".npmrc"]; # npm login token
      })
    ];
  };
}
