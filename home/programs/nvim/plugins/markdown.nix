{
  programs.nixvim.plugins = {
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
        MkdnCreateLinkFromClipboard = {
          key = "<leader>lc";
          modes = [ "n" "v" ];
        };
        MkdnDestroyLink = {
          key = "<leader>dl";
          modes = "n";
        };
        MkdnFollowLink = false;
        MkdnNextLink = {
          key = "<Tab>";
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
        MkdnPrevLink = {
          key = "<S-Tab>";
          modes = "n";
        };

        MkdnDecreaseHeading = {
          key = "-";
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
        MkdnGoForward = {
          key = "<Del>";
          modes = "n";
        };
        MkdnIncreaseHeading = {
          key = "+";
          modes = "n";
        };
        MkdnMoveSource = {
          key = "<F2>";
          modes = "n";
        };
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
          key = "<leader>ft";
          modes = "n";
        };
        MkdnTableNewColAfter = {
          key = "<leader>ic";
          modes = "n";
        };
        MkdnTableNewColBefore = {
          key = "<leader>iC";
          modes = "n";
        };
        MkdnTableNewRowAbove = {
          key = "<leader>iR";
          modes = "n";
        };
        MkdnTableNewRowBelow = {
          key = "<leader>ir";
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
}
