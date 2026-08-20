require("oil").setup({
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ["<C-v>"] = { "actions.select", opts = { vertical = true } }, -- to open file in vertical with oil
  },
})
