-- I use the Mason package manager to d/l and manage LSP servers.
--   See `./packages.lua`
--
-- LSP functionality is native in neovim.
--   `:h lsp`
--
-- I use a filetype ftplugin to start a specific lsp per filetype.
--   This is simpler for me right now than configuring an LSP config
--   with filetypes for every LSP, or downloading a bunch of pre-made
--   configs.
--   Most people use the default configs collection approach, though.
vim.lsp.enable({
    "bashls",
    "gopls",
    "lua_ls",
    "tsgo",
    "clangd",
})

-- TODO: trigger lsp loading based on treesitter grammar for multi-language files.
