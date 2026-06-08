{
  pkgs,
  pkgs-stable,
}:
(with pkgs; [
  go
  claude-code
])
++ (with pkgs-stable; [
  nodejs
  air
  duckdb
  docker
  python3
  jq
  nix-prefetch-github
  rsync
])
