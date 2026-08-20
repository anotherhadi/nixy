# ftplugin/
Stand for file type plugin 

Neovim runs any file in `ftplugin/` automatically when a matching filetype is opened.
The filename is the filetype selector:

```
ftplugin/svelte.lua     → runs when you open a .svelte file
ftplugin/go.lua         → runs when you open a .go file
ftplugin/python.lua     → runs when you open a .py file
```

It exists because some features are **not enabled globally** — they need to be
activated per filetype. Treesitter highlighting is one of them:

```lua
-- ftplugin/svelte.lua
vim.treesitter.start()
```

That's it. One line, scoped to svelte only.

## Location

```
~/.config/nvim/ftplugin/svelte.lua
```

NvChad never touches this folder — it's gitignored by NvChad and fully yours.
