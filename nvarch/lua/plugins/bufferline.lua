-- Bufferline.nvim doesn't create anything new — it just draws a clickable tab bar showing the files (buffers) you already have open in Neovim.
return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function ()
    require("bufferline").setup()
  end
}
