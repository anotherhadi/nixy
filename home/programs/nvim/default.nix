{ inputs, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./plugins/auto-pairs.nix
    ./plugins/bufferline.nix
    ./plugins/lazygit.nix
    ./plugins/telescope.nix
    ./plugins/nvim-tree.nix
    ./plugins/lightline.nix
    ./plugins/git.nix
    ./plugins/cmp.nix
    ./plugins/none-ls.nix
    ./plugins/wilder.nix
    ./plugins/lsp.nix
    ./plugins/treesitter.nix
    ./plugins/toggleterm.nix
    ./plugins/copilot.nix
    ./plugins/whichkey.nix
    ./plugins/alpha.nix
    ./plugins/keymaps.nix
    ./plugins/comment.nix
    ./plugins/oil.nix
    ./plugins/trouble.nix
    ./plugins/tmux-navigator.nix
    ./plugins/noice.nix
    ./plugins/obsidian.nix
    ./options.nix
    ./colorscheme.nix
  ];
}