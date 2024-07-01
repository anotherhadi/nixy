{
  programs.nixvim.plugins = {
    mkdnflow = {
        enable = true;
        mappings = {
            MkdnCreateLink = false;
            MkdnCreateLinkFromClipboard = {
                key = "<leader>p";
                modes = [
                "n"
                "v"
                ];
            };
            MkdnDecreaseHeading = {
                key = "-";
                modes = "n";
            };
            MkdnDestroyLink = {
                key = "<M-CR>";
                modes = "n";
            };
            MkdnEnter = {
                key = "<CR>";
                modes = [
                "n"
                "v"
                "i"
                ];
            };
            MkdnExtendList = false;
            MkdnFoldSection = {
                key = "<leader>f";
                modes = "n";
            };
            MkdnFollowLink = false;
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
            MkdnNextLink = {
                key = "<Tab>";
                modes = "n";
            };
            MkdnPrevHeading = {
                key = "[[";
                modes = "n";
            };
            MkdnPrevLink = {
                key = "<S-Tab>";
                modes = "n";
            };
            MkdnSTab = false;
            MkdnTab = false;
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
                key = "<Tab>";
                modes = "i";
            };
            MkdnTableNextRow = false;
            MkdnTablePrevCell = {
                key = "<S-Tab>";
                modes = "i";
            };
            MkdnTablePrevRow = {
                key = "<M-CR>";
                modes = "i";
            };
            MkdnToggleToDo = {
                key = "<C-Space>";
                modes = [
                "n"
                "v"
                ];
            };
            MkdnUnfoldSection = {
                key = "<leader>F";
                modes = "n";
            };
            MkdnUpdateNumbering = {
                key = "<leader>nn";
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
  };
}