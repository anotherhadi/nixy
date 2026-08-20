-- Add your missing filetype (for exemple need to have the filetype yaml.docker-compose for the docker-compose.yaml files, to actiavte the correct lsp)
-- Filetype in Neovim is a buffer-local setting (filetype/ft) that tells Neovim what kind of file it's looking at (e.g. lua, yaml, python), which then drives syntax highlighting, indentation rules, LSP server attachment, and other filetype-specific plugins/autocmds.

vim.filetype.add({
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },
})
