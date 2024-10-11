# The render-markdown.nvim plugin is a plugin that renders markdown files in a neovim in a more readable way.
{ pkgs, config, inputs, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  muted = "#${config.lib.stylix.colors.base03}";
  background = "#${config.lib.stylix.colors.base00}";
in {

  programs.nixvim = {
    plugins.mkdnflow = {
      enable = true;
      modules = { conceal = false; };

      toDo.symbols = [ " " "-" "x" "!" "/" ];
      mappings = {
        MkdnCreateLink = false;
        MkdnCreateLinkFromClipboard = {
          key = "<leader>ml";
          modes = [ "n" "v" ];
        };
        MkdnDecreaseHeading = {
          key = "<leader>m-";
          modes = "n";
        };
        MkdnDestroyLink = false;
        MkdnEnter = {
          key = "<CR>";
          modes = [ "v" ];
        };
        MkdnExtendList = false;
        MkdnFoldSection = {
          key = "<leader>mf";
          modes = "n";
        };
        MkdnUnfoldSection = {
          key = "<leader>mF";
          modes = "n";
        };
        MkdnFollowLink = {
          key = "gd";
          modes = "n";
        };
        MkdnGoBack = false;
        MkdnGoForward = false;
        MkdnIncreaseHeading = {
          key = "<leader>m+";
          modes = "n";
        };
        MkdnMoveSource = false;
        MkdnNewListItem = false;
        MkdnNewListItemAboveInsert = {
          key = "O";
          modes = "n";
        };
        MkdnNewListItemBelowInsert = {
          key = "o";
          modes = "n";
        };
        MkdnNextHeading = {
          key = "<leader>m#";
          modes = "n";
        };
        MkdnNextLink = {
          key = "<S-Tab>";
          modes = "n";
        };
        MkdnPrevHeading = {
          key = "<leader>m*";
          modes = "n";
        };
        MkdnPrevLink = false;
        MkdnSTab = false;
        MkdnTab = false;
        MkdnTableNewColAfter = {
          key = "<leader>mc";
          modes = "n";
        };
        MkdnTableNewColBefore = {
          key = "<leader>mC";
          modes = "n";
        };
        MkdnTableNewRowAbove = {
          key = "<leader>mR";
          modes = "n";
        };
        MkdnTableNewRowBelow = {
          key = "<leader>mr";
          modes = "n";
        };
        MkdnTableNextCell = {
          key = "<Tab>";
          modes = "i";
        };
        MkdnTableNextRow = false;
        MkdnTablePrevCell = {
          key = "<S-Tab>";
          modes = "i";
        };
        MkdnTablePrevRow = false;
        MkdnToggleToDo = {
          key = "<C-Space>";
          modes = [ "n" "v" ];
        };
        MkdnUpdateNumbering = {
          key = "<leader>mn";
          modes = "n";
        };
        MkdnYankAnchorLink = {
          key = "ya";
          modes = "n";
        };
        MkdnYankFileAnchorLink = {
          key = "yfa";
          modes = "n";
        };
      };
    };
    extraFiles = {
      # TODO: Not working for some reasons
      "ftplugin/markdown.lua".text = ''
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
      '';
    };
    highlight = {
      RenderMarkdownBg.bg = background;
      RenderMarkdownH1.fg = accent;
      RenderMarkdownH2.fg = muted;
      RenderMarkdownH3.fg = muted;
      RenderMarkdownH4.fg = muted;
      RenderMarkdownH5.fg = muted;
      RenderMarkdownH6.fg = muted;
      RenderMarkdownTodo.fg = muted;
      RenderMarkdownWarning.fg = accent;
    };
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "markdown.nvim";
        src = inputs.plugin-markdown;
      })
    ];
    extraConfigLua =
      # lua
      ''
        require('render-markdown').setup({
          heading = {
            icons = { '# ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
            backgrounds = {
                'RenderMarkdownBg',
            },
            foregrounds = {
                'RenderMarkdownH1',
                'RenderMarkdownH2',
                'RenderMarkdownH3',
                'RenderMarkdownH4',
                'RenderMarkdownH5',
                'RenderMarkdownH6',
            },
          },
          checkbox = {
            unchecked = { highlight = 'RenderMarkdownTodo' },
            checked = { highlight = 'RenderMarkdownTodo' },
            custom = {
              pending = { raw = '[-]', rendered = '󰥔 ', highlight = 'RenderMarkdownTodo' },
              important = { raw = '[!]', rendered = ' ', highlight = 'RenderMarkdownWarning' },
              cancel = { raw = '[/]', rendered = '󱋬 ', highlight = 'RenderMarkdownTodo' },
            },
          },
        })
      '';
  };
}
