-- Plugin for auto configuration of lsp config --
return {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
}
