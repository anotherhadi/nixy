-- Auto closes brackets, quotes, and pairs while typing
return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true,
    opts = {}
    -- use opts = {} for passing setup options
    -- this is equivalent to setup({}) function
}
