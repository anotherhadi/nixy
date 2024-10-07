{ pkgs, ... }: {
  home.packages = with pkgs; [ ctags ];

  programs.nixvim = {
    plugins = {
      lualine = {
        enable = true;
        settings = {
          options = {
            sections = {
              lualine_a = [ "mode" ];
              lualine_b = [ ];
              lualine_c = [ ];
              lualine_y = [{
                __unkeyed-1 = "aerial";
                colored = true;
                cond = {
                  __raw = ''
                    function()
                      local buf_size_limit = 1024 * 1024
                      if vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0)) > buf_size_limit then
                        return false
                      end

                      return true
                    end
                  '';
                };
                dense = false;
                dense_sep = ".";
                depth = { __raw = "nil"; };
                sep = " ) ";
              }];
              lualine_z = [{ __unkeyed-1 = "location"; }];
            };
            tabline = {
              lualine_a = [{
                __unkeyed-1 = "buffers";
                symbols = { alternate_file = ""; };
              }];
              lualine_z = [ "tabs" ];
            };
          };
        };
      };
      dap.enable = true;
      web-devicons.enable = true;
      noice.enable = true;
      gitsigns = {
        enable = true;
        settings.current_line_blame = false;
      };
      trouble.enable = true;
      indent-blankline.enable = true;
      which-key.enable = true;
      nvim-colorizer.enable = true;
      tagbar = {
        enable = true;
        tagsPackage = pkgs.universal-ctags;
      };
    };
  };
}
