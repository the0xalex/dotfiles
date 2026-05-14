-- Simple plugin, I use it to:
--   - Store a map for setting a prefferred formatter
--     based on filetype
--   - autocommand for running formatting on save
--   - Use the lsp as a fallback if my preferred formatter
--     isn't available or lacks the config or whatever

vim.pack.add({
    "https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
    notify_on_error = false,
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    formatters_by_ft = {
        lua = { "stylua" },
        json = { "jq" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
    },
})
