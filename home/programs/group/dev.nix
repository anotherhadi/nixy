{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home = {
    packages = with pkgs-unstable;
      [
        go
        claude-code
      ]
      ++ (with pkgs; [
        nodejs
        air
        duckdb
        python3
        jq
        nix-prefetch-github
        rsync
      ]);

    persistence."/persist" = {
      directories = [
        ".claude"
      ];
      files = [".claude.json"];
    };

    sessionPath = ["$HOME/.local/share/go/bin"];
    sessionVariables.GOPATH = "$HOME/.local/share/go";
  };
}
