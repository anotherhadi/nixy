-- Integration of lazydocker inside neovim
return {
  "HoneyChasey/lazydocker.nvim",
  opts = {},
  keys = {
    {
      "<leader>ld",
      function()
        require("lazydocker").open()
      end,
      desc = "Open Lazydocker",
    },
  },
}
