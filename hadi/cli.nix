{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    ranger
    fd
    lazygit
    tree-sitter
    btop
    bitwarden-cli
  ];
}
