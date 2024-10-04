{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins/cmp.nix
    ./plugins/dashboard.nix
    ./plugins/lsp.nix
    ./plugins/markdown.nix
    ./plugins/tree.nix
    ./plugins/ui.nix
    ./plugins/utils.nix

    ./options.nix
    ./colorscheme.nix
    ./keymaps.nix
  ];

  programs.nixvim.enable = true;
}
