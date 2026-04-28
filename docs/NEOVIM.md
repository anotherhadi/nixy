# Neovim

The Neovim configuration is built with [nvf](https://github.com/notashelf/nvf) and exposed as a standalone flake output.
It can be used in three ways: run it directly, import it into another flake's home-manager setup, or use it as part of this config.

## Run directly

No installation needed:

```sh
nix run github:anotherhadi/nixy#nvim
```

## Use in another flake

Add this repo as an input:

```nix
inputs.nixy.url = "github:anotherhadi/nixy";
```

Then import the home-manager module in your home configuration:

```nix
{ inputs, ... }: {
  imports = [ inputs.nixy.homeManagerModules.nvim ];
}
```

## What's included

| File            | Description                                                            |
| --------------- | ---------------------------------------------------------------------- |
| `options.nix`   | Core settings: theme (catppuccin mocha), clipboard, indentation, folds |
| `languages.nix` | LSP, treesitter, formatters, diagnostics, and per-language config      |
| `keymaps.nix`   | All key mappings (leader: `space`)                                     |
| `picker.nix`    | Snacks picker + oil.nvim                                               |
| `snacks.nix`    | Snacks extras: image preview, zen mode, git signs, statuscolumn        |
| `utils.nix`     | Bufferline, lualine, copilot, lazygit, toggleterm, autocomplete        |
| `mini.nix`      | Mini.nvim suite: pairs, comment, icons, indentscope, diff, git         |
