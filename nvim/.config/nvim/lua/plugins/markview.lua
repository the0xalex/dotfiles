return {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    config = function()
        local heading_presets = require("markview.presets").headings

        require("markview").setup({
            headings = heading_presets.glow_labels,
        })
    end,
}
