return {
    -- Various tailwindcss lsp and completion tools.
    -- See https://github.com/luckasRanarison/tailwind-tools.nvim
    "luckasRanarison/tailwind-tools.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
        document_color = {
            enabled = false,
            kind = "inline",
            inline_symbol = "󰝤 ",
            debounce = 200,
        },
        conceal = {
            enabled = false,
            symbol = "󱏿",
            highlight = {
                fg = "#38BDF8",
            },
        },
        custom_filetypes = {},
    },
}
