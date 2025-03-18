{ config, ... }:
let
  accent = "#${config.lib.stylix.colors.base0D}";
  muted = "#${config.lib.stylix.colors.base03}";
in {
  programs.nixvim = {
    # Markdown settings
    extraFiles."after/ftplugin/markdown.lua".text = ''
      vim.bo.tabstop = 2
      vim.bo.shiftwidth = 2
      vim.bo.expandtab = true 
    '';

    # Highlight colors
    highlight = {
      Headline1 = {
        bg = "#4B4266";
        fg = accent;
      };
      Headline2 = {
        bg = "#3B575E";
        fg = "#9FFEFE";
      };
      Headline3 = {
        bg = "#3B5742";
        fg = "#9FFE9F";
      };
      Headline4 = {
        bg = "#574842";
        fg = "#FECB9F";
      };

      RenderMarkdownTodo.fg = "#f78c6c";
      RenderMarkdownWarning.fg = "#ff5370";
      RenderMarkdownDone.fg = muted;
    };

    # Plugins
    plugins = {
      # This one takes care of the markdown titles
      headlines = {
        enable = true;
        settings = {
          markdown = {
            headline_highlights =
              [ "Headline1" "Headline2" "Headline3" "Headline4" ];
          };
        };
      };

      # MkdnFlow is a plugin that helps you navigate markdown files
      mkdnflow = {
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

      # Render UI elements
      render-markdown = {
        enable = true;
        settings = {
          heading = { enabled = false; };
          checkbox = {
            unchecked = { highlight = "RenderMarkdownTodo"; };
            checked = { highlight = "RenderMarkdownDone"; };
            custom = {
              pending = {
                raw = "[-]";
                rendered = " ";
                highlight = "RenderMarkdownTodo";
              };
              important = {
                raw = "[!]";
                rendered = "󰰱 ";
                highlight = "RenderMarkdownWarning";
              };
              cancel = {
                raw = "[/]";
                rendered = "󱋬 ";
                highlight = "RenderMarkdownWarning";
              };
            };
          };
        };
      };
    };
  };
}
