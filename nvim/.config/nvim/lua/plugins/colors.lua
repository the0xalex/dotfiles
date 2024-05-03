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
    -- {
    --     "scottmckendry/cyberdream.nvim",
    --      lazy = false,
    --      priority = 1000,
    --      config = function()
    --         transparent = true,
    --         italic_comments = true,
    --         hide_fillchars = true,
    --         borderless_telescope = true,
    --         terminal_colors = false,
    --         theme = {
    --             colors = {
    --                 bgHighlight = "#0066cc",
    --             },
    --         },
    --         end,
    --         vim.cmd.colorscheme("cyberdream")
    --     },
    { "folke/tokyonight.nvim" },  -- The OG that the GOAT was based-on
    { "rose-pine/neovim" },       -- I like this for some languages
    { "catppuccin/nvim" },        -- other people like this.
    { "lunarvim/darkplus.nvim" }, -- for kids who recently evolved past vscode (honestly very complete)
    { "rebelot/kanagawa.nvim" },
}
