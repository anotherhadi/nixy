local servers = require("configs.servers")

vim.lsp.enable(servers)


vim.diagnostic.config({
  virtual_text = true,
  virtual_lines = false}) -- display lsp diagnostic in line for the user. Change current_line to true to display only the diagnostic when cursor is on the specific line. Only work natively with neovim >= 0.11


--vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
--
-- Hightlighing sames variables. May break after change, so check news on neovim
local function lsp_highlight_document(client)
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_exec([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
            ]],
        false)
    end
end

-- Attach the fuction after the lps on the current buffer load. Thx Claude
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        lsp_highlight_document(client)
    end,
})
