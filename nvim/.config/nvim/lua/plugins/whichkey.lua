return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
        require("which-key").setup()

        -- TODO:
        -- Document existing key chains
        require("which-key").register({
            ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
            ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
            ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
        })
    end,
}
