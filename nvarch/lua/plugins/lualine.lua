-- Plugin for status line written in pure lua. Change the config inside the folder config
return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    config = function()
      require("configs.lualine")
    end
}
