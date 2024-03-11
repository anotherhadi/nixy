{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    go
    cargo
    nodejs
    python3
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stylua
    lua-language-server
  ];
}
