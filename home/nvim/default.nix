{ pkgs, inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./auto-pairs.nix
    ./options.nix
    ./bufferline.nix
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
  ];

  programs.nixvim = {

    enable = true;

    colorschemes.catppuccin.enable = true;
    colorschemes.catppuccin.transparentBackground = true;

    keymaps = [
      {
        key = "<leader>e";
        action = "<CMD>Neotree toggle<CR>";
      }
      {
        key = "<space>fm";
        action = "<CMD>lua vim.lsp.buf.format()<CR>";
      }

      # Terminal Mappings
      {
        mode = "t";
        key = "<esc>";
        action = "<C-\\><C-n>";
      }
    ];
  };

}
