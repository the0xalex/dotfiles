-- I started editing a tabletop simulator game, and learned there
--  wasn't any neovim integration with their editor api.
--
-- I made one for what I needed.  This adds it and sets it up.

vim.pack.add({ {
    src = "https://github.com/the0xalex/tabletop-simulator.nvim",
    version = "main",
} })

return require("tts").setup({
    keymaps = {
        load = "<leader>T",
        save = "<leader>t",
    },
})
