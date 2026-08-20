return {
  require('nvim-treesitter').install {'svelte'}, -- write your languages here, to be install 

  require('nvim-treesitter').setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath('data') .. '/site' -- folder is located in ~/.local/share/nvim/site/queries
  }
}
