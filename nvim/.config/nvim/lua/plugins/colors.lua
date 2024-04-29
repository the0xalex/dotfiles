return {
    -- Preview and select them with `:Telescope colorschemes`
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                transparent = true,
                italic_comments = true,
                hide_fillchars = true,
                borderless_telescope = true,
                terminal_colors = true,
                theme = {
                    colors = {
                        bgHighlight = "#0066cc",
                    },
                },
            })
            vim.cmd.colorscheme("cyberdream")
        end,
    },
    { "lunarvim/lunar.nvim" },
    { "folke/tokyonight.nvim" },  -- The OG that the GOAT was based-on
    { "rose-pine/neovim" },       -- I like this for some languages
    { "catppuccin/nvim" },        -- other people like this.
    { "lunarvim/darkplus.nvim" }, -- for kids who recently evolved past vscode (honestly very complete)
    { "rebelot/kanagawa.nvim" },
}
