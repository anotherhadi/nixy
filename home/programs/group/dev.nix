{
  pkgs,
  pkgs-stable,
  ...
}: {
  home.packages = with pkgs;
    [
      go
      claude-code
    ]
    ++ (with pkgs-stable; [
      nodejs
      air
      duckdb
      python3
      jq
      nix-prefetch-github
      rsync
    ]);
}
