return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        require("which-key").setup()

        -- TODO:
        -- Document existing key chains
        -- require("which-key").register({
        --     { "", group = "[S]earch" },
        -- })
    end,
}
