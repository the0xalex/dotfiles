-- My preferred colorscheme

vim.pack.add({
    "https://github.com/folke/tokyonight.nvim",
})

require("tokyonight").setup({
    style = "night",
    on_colors = function(c)
        c.comment = "#6f6fb8"
        c.bg_highlight = "#292e52"
    end,
    on_highlights = function(hl, c)
        hl.Visual = {
            bg = "#2020e0",
            fg = "#ffffff",
        }
        hl.DiagnosticUnnecessary = {
            fg = c.comment,
        }
    end,
})
vim.cmd.colorscheme("tokyonight-night")
