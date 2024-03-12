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
    ./copilot.nix
    ./obsidian.nix
    ./whichkey.nix
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

      {
        key = "<leader>ot";
        action = "<cmd>lua require('obsidian').util.toggle_checkbox()<cr>";
      }

      {
        key = "<leader>oo";
        action = "<cmd>ObsidianQuickSwitch<cr>";
      }

      {
        key = "<leader>on";
        action = "<cmd>ObsidianNew<cr>";
      }

      {
        key = "<leader>of";
        action = "<cmd>ObsidianSearch<cr>";
      }

      {
        key = "<leader>oi";
        action = "<cmd>ObsidianPasteImg<cr>";
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
