{
  vim.luaConfigRC.mini-clue = ''
    local miniclue = require('mini.clue')
    miniclue.setup({
      triggers = {
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'n', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = 'n', keys = 'z' },
      },
      clues = {
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows({ submode_resize = true }),
        miniclue.gen_clues.z(),
        { mode = 'n', keys = '<Leader>f', desc = '+find' },
        { mode = 'n', keys = '<Leader>s', desc = '+search' },
        { mode = 'n', keys = '<Leader>t', desc = '+terminal' },
        { mode = 'n', keys = '<Leader>u', desc = '+ui' },
        { mode = 'n', keys = '<Leader>l', desc = '+lsp' },
        { mode = 'n', keys = '<Leader>x', desc = '+trouble' },
      },
      window = { delay = 300 },
    })
  '';

  vim.mini = {
    ai.enable = true;
    starter.enable = true;
    comment.enable = true;
    icons.enable = true;
    indentscope.enable = true;
    pairs.enable = true;
    diff.enable = true;
    git.enable = true;
    jump2d.enable = true;
    statusline.enable = true;
    clue.enable = true;
  };
}
