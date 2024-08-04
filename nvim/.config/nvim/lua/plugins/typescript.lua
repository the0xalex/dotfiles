return {
    {
        "pmizio/typescript-tools.nvim", -- TypeScript tools
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        ft = { "typescript", "typescriptreact" },
        opts = {},
    },
    {
        "windwp/nvim-ts-autotag",
        ft = { "typescript", "typescriptreact" },
        opts = {},
    },
}
