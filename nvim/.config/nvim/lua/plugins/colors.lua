return {
    -- Preview and select them with `:Telescope colorschemes`
    {
        "folke/tokyonight.nvim", -- The GOAT
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "night",
                on_colors = function(c)
                    c.comment = "#6f6fb8"
                    c.bg_highlight = "#292e52"
                end,
                on_highlights = function(hl, _)
                    hl.Visual = {
                        bg = "#2020e0",
                        fg = "#ffffff",
                    }
                end,
            })
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },
    { "rose-pine/neovim" },       -- I like this for some languages
    { "catppuccin/nvim" },        -- other people like this.
    { "lunarvim/darkplus.nvim" }, -- for kids who recently evolved past vscode (honestly very complete)
}
