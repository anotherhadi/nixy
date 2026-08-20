-- display a tree of your current files. I add this if i really need to have tree file structure inside neovim. This is why i use leader + tr (for leader tree)
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
  },
  lazy = false, -- neo-tree will lazily load itself
  config = function()
    require("configs.neo-tree")
  end,
}
