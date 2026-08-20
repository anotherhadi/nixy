-- Autocompletion engine with LSP, buffer, and path sources
return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'onsails/lspkind.nvim',
  },
  config = function()
    local cmp = require('cmp')
    local lspkind = require('lspkind')

    cmp.setup({
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'path' },
      }, {
        { name = 'buffer' },
      }),
      formatting = {
        fields = { 'abbr', 'icon', 'kind', 'menu' },
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          preset = 'default', -- Nerd Fonts icon set
          -- preset = 'codicons', -- Vscode codicons icon set (must be dowloaded after)
          maxwidth = {
            menu = 50,
            abbr = 50,
          },
          ellipsis_char = '...',
          show_labelDetails = true,
        })
      },
    })

    vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })
  end
}
