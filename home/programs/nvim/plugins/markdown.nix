# The render-markdown.nvim plugin is a plugin that renders markdown files in a neovim in a more readable way.
{ config, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  accent-alt = "#${config.lib.stylix.colors.base08}";
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
        MkdnNextLink = false;
        MkdnPrevLink = false;
        MkdnPrevHeading = {
          key = "<leader>m*";
          modes = "n";
        };
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
          key = "<S-Tab>";
          modes = "n";
        };
        MkdnTableNextRow = false;
        MkdnTablePrevCell = {
          key = "<S-Tab>";
          modes = "n";
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
      "after/ftplugin/markdown.lua".text = ''
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.expandtab = true 
      '';
    };
    highlight = {
      RenderMarkdownBg.bg = background;
      RenderMarkdownH1.fg = accent;
      RenderMarkdownH2.fg = accent;
      RenderMarkdownH3.fg = accent-alt;
      RenderMarkdownH4.fg = accent-alt;
      RenderMarkdownH5.fg = accent-alt;
      RenderMarkdownH6.fg = accent-alt;
      RenderMarkdownTodo.fg = muted;
      RenderMarkdownWarning.fg = accent;
    };
    plugins.headlines = {
      enable = true;
      settings = {
        markdown = {
          headline_highlights = [
            "RenderMarkdownH1"
            "RenderMarkdownH2"
            "RenderMarkdownH3"
            "RenderMarkdownH4"
            "RenderMarkdownH5"
            "RenderMarkdownH6"
          ];
          fat_headlines = false;
        };
      };
    };
    plugins.render-markdown = {
      enable = true;
      settings = {
        heading = {
          icons = [ "# " "󰲣 " "󰲥 " "󰲧 " "󰲩 " "󰲫 " ];
          backgrounds = [ "RenderMarkdownBg" ];
          foregrounds = [
            "RenderMarkdownH1"
            "RenderMarkdownH2"
            "RenderMarkdownH3"
            "RenderMarkdownH4"
            "RenderMarkdownH5"
            "RenderMarkdownH6"
          ];
        };
        checkbox = {
          unchecked = { highlight = "RenderMarkdownTodo"; };
          checked = { highlight = "RenderMarkdownTodo"; };
          custom = {
            pending = {
              raw = "[-]";
              rendered = "󰥔 ";
              highlight = "RenderMarkdownTodo";
            };
            important = {
              raw = "[!]";
              rendered = " ";
              highlight = "RenderMarkdownWarning";
            };
            cancel = {
              raw = "[/]";
              rendered = "󱋬 ";
              highlight = "RenderMarkdownTodo";
            };
          };
        };
      };
    };
  };
}
