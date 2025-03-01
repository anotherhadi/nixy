{
  programs.nixvim = {
    autoGroups = {
      highlightyank.clear = true;
      q_close_windows.clear = true;
    };

    autoCmd = [
      # highlightyank
      # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L206-L211
      {
        desc = "Highlight yanked text";
        event = "TextYankPost";
        group = "highlightyank";
        pattern = "*";

        callback.__raw = ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }

      # q_close_windows
      # https://github.com/AstroNvim/AstroNvim/blob/v4.7.7/lua/astronvim/plugins/_astrocore_autocmds.lua#L242-L255
      {
        desc = "Make q close help, man, quickfix, dap floats";
        event = "BufWinEnter";
        group = "q_close_windows";

        callback.__raw = ''
          function(event)
            if vim.tbl_contains({ "help", "nofile", "quickfix" }, vim.bo[event.buf].buftype) then
              vim.keymap.set("n", "q", "<Cmd>close<CR>", {
                desc = "Close window",
                buffer = event.buf,
                silent = true,
                nowait = true,
              })
            end
          end
        '';
      }
    ];
  };
}
