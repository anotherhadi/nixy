-- Formator plugin (indentation, spacing, line, lenght etc etc).
return {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
}
