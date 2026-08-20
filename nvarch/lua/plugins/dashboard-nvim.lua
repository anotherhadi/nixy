-- dashboad when opening your neovim
return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("configs.dashboard-nvim")
  end
}
