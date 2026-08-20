local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })

map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
map("i", "<C-e>", "<End>", { desc = "move end of line" })
map("i", "<C-h>", "<Left>", { desc = "move left" })
map("i", "<C-l>", "<Right>", { desc = "move right" })
map("i", "<C-j>", "<Down>", { desc = "move down" })
map("i", "<C-k>", "<Up>", { desc = "move up" })

map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

map("n", "<C-s>", "<cmd>w<CR>", { desc = "general save file" })
map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "general copy whole file" })

map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })

-- REMOVED: <leader>ch NvCheatsheet (was NvChad UI only)
-- which-key already covers "show all keymaps" via <leader>wK below

map({ "n", "x" }, "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "general format file" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "LSP diagnostic loclist" })
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP go to definition"})

-- bufferline (replaces tabufline)
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "buffer goto next" })

map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "buffer goto prev" })

map("n", "<leader>x", ":bd!<CR>", { desc = "buffer close, keep window" }) -- S/O to this guy https://stackoverflow.com/questions/1444322/how-can-i-close-a-buffer-without-closing-the-window and to this guy also https://stackoverflow.com/questions/1269648/how-do-i-close-a-single-buffer-out-of-many-in-vim

-- :b# switches the current window to the alternate buffer (the previously active one)
-- |bd# then deletes what is now the alternate buffer — which is the buffer you just left

-- Comment
map("n", "<leader>/", "gcc", { desc = "toggle comment", remap = true })
map("v", "<leader>/", "gc", { desc = "toggle comment", remap = true })

-- oil
map("n", "<leader>e", "<cmd>Oil<CR>", { desc = "open oil (file explorer)" })

-- neo-tree
map("n", "<leader>tr", "<cmd>Neotree<CR>", {desc = "Open neotree (tree file explorer)"})

-- telescope
map("n", "<leader>fw", function() -- telescope live grep with dotfiles
  require("telescope.builtin").live_grep({
    additional_args = function()
      return { "--hidden" }
    end,
  })
end, { desc = "telescope live grep (hidden)" })


map("n", "<leader>ff", function() -- telescope find file with dotfiles
  require("telescope.builtin").find_files({
    hidden = true,
    file_ignore_patterns = { "%.git/" },
  })
end, { desc = "telescope find files (with hidden)" })

map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
map("n", "<leader>gt", "<cmd>Telescope git_status<CR>", { desc = "telescope git status" })
map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })

--- theme picker (replaces nvchad.themes)
map("n", "<leader>th", "<cmd>Telescope colorscheme<CR>", { desc = "telescope colorscheme picker" })


-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })


-- new terminals (replaces nvchad.term, using toggleterm.nvim)
map("n", "<leader>h", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "terminal new horizontal term" })

map("n", "<leader>v", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "terminal new vertical term" })

-- toggleable (toggleterm supports numbered term instances as unique ids)
map({ "n", "t" }, "<A-v>", "<cmd>2ToggleTerm direction=vertical<CR>", { desc = "terminal toggleable vertical term" })

map({ "n", "t" }, "<A-h>", "<cmd>3ToggleTerm direction=horizontal<CR>", { desc = "terminal toggleable horizontal term" })

map({ "n", "t" }, "<A-i>", "<cmd>4ToggleTerm direction=float<CR>", { desc = "terminal toggle floating term" })

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- Plugin part

-- Lazygit mapping
map("n", "<leader>g", "<cmd>lua require('lazygit').lazygit()<CR>", { desc = "Open LazyGit" })
-- Telescope mapping
map('n', '<leader>f', ':Telescope find_files<CR>')
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- vim inlay hint mapping
vim.keymap.set('n', '<leader>ih', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }))
end, { desc = '[T]oggle Inlay [H]ints' })
