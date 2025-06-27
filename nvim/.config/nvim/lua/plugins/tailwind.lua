return {
    -- Various tailwindcss lsp and completion tools.
    -- See https://github.com/luckasRanarison/tailwind-tools.nvim
    "luckasRanarison/tailwind-tools.nvim",
    name = "tailwind-tools",
    build = ":UpdateRemotePlugins",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = {
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
        "gsp",
        "astro",
        "templ",
    },
    -- ---@type TailwindTools.Option
    opts = {
        document_color = {
            enabled = true,
            -- ---@type TailwindTools.ColorHint
            kind = "background",
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
        extension = {
            queries = {
                "typescriptreact",
                "tsx",
            },
        },
    },
}
