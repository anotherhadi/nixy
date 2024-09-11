{ pkgs, inputs, ... }: {
  programs.nixvim = {
    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "markdown.nvim";
        src = inputs.plugin-markdown;
      })
    ];
    extraConfigLua = "require('render-markdown').setup({})";
    plugins = {
      mkdnflow = {
        enable = true;
        mappings = {

          # Main
          MkdnEnter = {
            key = "<CR>";
            modes = [ "n" "v" "i" ];
          };

          # Links
          MkdnCreateLink = false;
          MkdnCreateLinkFromClipboard = false;
          MkdnDestroyLink = false;
          MkdnFollowLink = false;
          MkdnNextLink = {
            key = "<Tab>";
            modes = "n";
          };
          MkdnPrevLink = {
            key = "<S-Tab>";
            modes = "n";
          };
          MkdnYankAnchorLink = false;
          MkdnYankFileAnchorLink = false;
          MkdnDecreaseHeading = {
            key = "-";
            modes = "n";
          };
          MkdnIncreaseHeading = {
            key = "+";
            modes = "n";
          };
          MkdnExtendList = false;
          MkdnFoldSection = {
            key = "<leader>ff";
            modes = "n";
          };
          MkdnUnfoldSection = {
            key = "<leader>fu";
            modes = "n";
          };
          MkdnGoBack = {
            key = "<BS>";
            modes = "n";
          };
          MkdnGoForward = false;
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
            key = "]]";
            modes = "n";
          };
          MkdnPrevHeading = {
            key = "[[";
            modes = "n";
          };
          MkdnSTab = false;
          MkdnTab = false;
          MkdnTableFormat = {
            key = "<leader>tf";
            modes = "n";
          };
          MkdnTableNewColAfter = {
            key = "<leader>tc";
            modes = "n";
          };
          MkdnTableNewColBefore = {
            key = "<leader>tC";
            modes = "n";
          };
          MkdnTableNewRowAbove = {
            key = "<leader>tR";
            modes = "n";
          };
          MkdnTableNewRowBelow = {
            key = "<leader>tr";
            modes = "n";
          };
          MkdnTableNextCell = {
            key = "<S-Tab>";
            modes = "i";
          };
          MkdnTableNextRow = false;
          MkdnTablePrevCell = {
            key = "<M-Tab>";
            modes = "i";
          };
          MkdnTablePrevRow = {
            key = "<M-CR>";
            modes = "i";
          };
          MkdnToggleToDo = {
            key = "<C-Space>";
            modes = [ "n" "v" ];
          };
          MkdnUpdateNumbering = {
            key = "<leader>nn";
            modes = "n";
          };
        };
      };
    };
  };
}
