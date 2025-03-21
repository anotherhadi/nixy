{ pkgs, ... }: {
  home.packages = with pkgs; [ ctags ];

  programs.nixvim = {
    plugins = {
      trouble.enable = true;
      which-key.settings.spec = [{
        __unkeyed-1 = "<leader>t";
        mode = "n";
        group = "+trouble";
      }];
    };
    keymaps = [
      {
        key = "<leader>tx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        key = "<leader>tX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options.desc = "Buffer Diagnostics (Trouble)";
      }
      {
        key = "<leader>ts";
        action = "<cmd>Trouble symbols toggle focus=false<cr>";
        options.desc = "Symbols (Trouble)";
      }
      {
        key = "<leader>tl";
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<cr>";
        options.desc = "LSP Definitions / references / ... (Trouble)";
      }
      {
        key = "<leader>tL";
        action = "<cmd>Trouble loclist toggle<cr>";
        options.desc = "Location List (Trouble)";
      }
      {
        key = "<leader>tQ";
        action = "<cmd>Trouble qflist toggle<cr>";
        options.desc = "Quickfix List (Trouble)";
      }
    ];
  };
}
