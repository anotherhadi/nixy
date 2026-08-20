vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- bootstrap + setup lazy.nvim (loads all plugins from lua/plugins/)
require("configs.lazy")

-- bootstrap for theemes

require "options"
require "autocmds"
require("configs.filetype")


vim.opt.termguicolors = true -- Without this, color highlighting won't render correctly (or at all) in many terminals. Also is use and necessary for the plugin nvim-colorizer.lua

vim.cmd.colorscheme("cyberdream") -- change here your default theme

vim.schedule(function()
  require "mappings"
end)
