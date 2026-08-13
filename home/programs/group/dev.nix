{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.packages = with pkgs-unstable;
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
}
