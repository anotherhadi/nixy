{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./auto-pairs.nix
    ./options.nix
    ./telescope.nix
    ./nvim-tree.nix
    ./lightline.nix
    ./git.nix
    ./cmp.nix
    ./none-ls.nix
    ./wilder.nix
    ./lsp.nix
    ./treesitter.nix
    ./toggleterm.nix
    ./whichkey.nix
    ./alpha.nix
    ./keymaps.nix
    ./comment.nix
    ./oil.nix
    ./trouble.nix
    ./noice.nix
  ];

  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings = { transparent_background = true; };
    };
  };

}
