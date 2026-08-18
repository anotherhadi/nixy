# Nvarch is minial config for neovim. This nix provide you the recommended instalation for your nixOs
{pkgs, ...}: let
  myTex = pkgs.texliveBasic.withPackages (ps:
    with ps; [
      collection-latex
      collection-latexrecommended
      collection-fontsrecommended
      collection-latexextra
      collection-binextra
    ]);
in {
  home.packages = with pkgs; [
    neovim
    ripgrep
    lazydocker
    luarocks
    unixodbc
    wl-clipboard
    zathura
    tesseract
    myTex
  ];
}
