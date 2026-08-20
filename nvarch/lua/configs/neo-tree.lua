require("neo-tree").setup({
  filesystem = {
    filtered_items = {
      visible = false,        -- if true, hidden items are dimmed instead of removed
      hide_dotfiles = false,  -- show dotfiles (.env, .eslintrc, etc.)
      hide_gitignored = true, -- keep gitignored files hidden (optional, your call)
      hide_by_name = {
        -- other names you want hidden but toggleable with 'H'
      },
      never_show = {
        ".git", -- always hidden, even with 'H' toggle
      },
    },
  },
})
