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

    plugins.alpha = {
      enable = true;
      layout = [
        {
          type = "padding";
          val = 4;
        }
        {
          type = "text";
          opts = { position = "center"; };
          val = [
            "                                                                     "
            "       ████ ██████           █████      ██                     "
            "      ███████████             █████                             "
            "      █████████ ███████████████████ ███   ███████████   "
            "     █████████  ███    █████████████ █████ ██████████████   "
            "    █████████ ██████████ █████████ █████ █████ ████ █████   "
            "  ███████████ ███    ███ █████████ █████ █████ ████ █████  "
            " ██████  █████████████████████ ████ █████ █████ ████ ██████ "
            "                                                                       "
          ];
        }
        {
          type = "padding";
          val = 4;
        }
        {
          type = "group";
          val = [
            {
              type = "button";
              val = "  New file";
              on_press.__raw = "function() vim.cmd[[ene]] end";
              opts = {
                shortcut = "n";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "button";
              val = "  NixOs Config";
              on_press.__raw = "function() vim.cmd[[e ~/.config/nixos]] end";
              opts = {
                shortcut = "c";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "button";
              val = "󰩈  Quit Neovim";
              on_press.__raw = "function() vim.cmd[[qa]] end";
              opts = {
                shortcut = "q";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
          ];
        }
      ];
    };

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
