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

  xdg.configFile.nvim.source = ../../../../dotfiles/nvarch; # Add all the config in ~/.config/nvim -- you should comment this line, config for my nixos
  
  # LSP
  # You should't install here lsp, but only when is nedeed, on your current projects path.

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
