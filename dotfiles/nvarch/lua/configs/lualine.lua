require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = {
      {
        function()
          local mode = require('lualine.utils.mode').get_mode()
          return ' ' .. mode -- Neovim logo + mode, one string
        end,
      }
    },
    lualine_b = {
      {
        'branch',
        icon = '', -- custom git branch icon
      },
      'diff',
      {
        'diagnostics',
        sources = { 'nvim_lsp' }, -- only show LSP diagnostics
      },
    },
    lualine_c = {'filename'},
lualine_x = {
  {
    function()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return ''
      end
      local names = {}
      for _, client in ipairs(clients) do
        table.insert(names, client.name)
      end
      return ' ~ ' .. table.concat(names, ', ') -- LSP logo + names, one string
    end,
    color = { fg = '#98c379' },
  },
  'fileformat',
  'filetype'
},
    lualine_y = {''},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
