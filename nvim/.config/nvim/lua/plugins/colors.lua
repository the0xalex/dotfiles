return {
    -- Preview and select them with `:Telescope colorschemes`
    {
        "lunarvim/lunar.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("lunar")
        end,
    },
    { "folke/tokyonight.nvim" },  -- The OG that the GOAT was based-on
    { "rose-pine/neovim" },       -- I like this for some languages
    { "catppuccin/nvim" },        -- other people like this.
    { "lunarvim/darkplus.nvim" }, -- for kids who recently evolved past vscode (honestly very complete)
}
