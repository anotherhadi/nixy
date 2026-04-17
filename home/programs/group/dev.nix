{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    go
    bun
    docker
    nodejs
    python3
    jq
    just
    air
    duckdb
    inputs.bun2nix.packages.${stdenv.hostPlatform.system}.default
    claude-code
  ];
}
