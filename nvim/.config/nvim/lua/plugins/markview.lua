return {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    config = function()
        local presets = require("markview.presets")
        require("markview").setup({
            headings = presets.headings.decorated_labels,
        })
    end,

    dependencies = {
        -- You may not need this if you don't lazy load
        -- Or if the parsers are in your $RUNTIMEPATH
        "nvim-treesitter/nvim-treesitter",
        -- "nvim-tree/nvim-web-devicons",
    },
}
