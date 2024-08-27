-- See `:h nvim-treesitter`
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "bash", "c", "html", "lua", "markdown", "vim", "vimdoc" },
            -- Autoinstall languages that are not installed
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })

        -- Treesitter node introspection is part of nvim core now.
        -- - :Inspect
        -- - :InspectTree
        -- - :EditQuery
    end,
}
