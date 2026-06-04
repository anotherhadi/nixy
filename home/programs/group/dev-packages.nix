{
  pkgs,
  pkgs-stable,
  inputs,
  system,
}:
(with pkgs; [
  go
  bun
  nodejs
  claude-code
  inputs.bun2nix.packages.${system}.default
])
++ (with pkgs-stable; [
  air
  duckdb
  docker
  python3
  jq
  just
  nix-prefetch-github
  rsync
])
