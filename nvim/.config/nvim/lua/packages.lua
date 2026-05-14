-- Since neovim 0.12, I use the builtin package manager
--   see `:h vim.pack`

--   These plugins are also basically specialized package managers.
--   One for treesitter parsers and one for LSPs.
--
--   I use these instead of managing them myself, because it
--     allows me to quickly open a language I don't often see or have never seen,
--     and just grab some quick defaults without thinking about it.

vim.pack.add({
    "https://github.com/nvim-treesitter/nvim-treesitter",
    "https://github.com/mason-org/mason.nvim", -- LSP Server Manager :Mason
})

require("mason").setup({})

-- The plugin `nvim-treesitter` calls the `tree-sitter-cli` to do most things.
--   Install it using the system package manager
--   ```bash
--   #macOS
--   brew install tree-sitter-cli
--   ```
--
-- Treesitter node introspection is part of nvim core as of 0.11
--   - :Inspect
--   - :InspectTree
--   - :EditQuery

--   TODO: Check the capabilities are good before calling this.
require("nvim-treesitter").install({
    "go",
    "rust",
    "swift",
    "typescript",
    "javascript",
    "zig",
})

-- I've put modules that are NOT related to package management
--   in the `./plugins` directory.  The below code requires them all,
--   and summarizes a list of any that failed to run during neovim startup.
--   To create another plugin and run it on launch, just put the lua module
--   the plugins dir and add it here.

-- stylua: ignore
local plugins = {
    "plugins.mini",             -- surrounds, text objects, file browser, all sorts of goodies
    "plugins.todos",            -- Parses out certain comments and sets highlight color
    "plugins.colors",           -- Colorscheme
    "plugins.conform",          -- Autoformat
    "plugins.lualine",          -- All statusline stuff
    "plugins.gitsigns",         -- Git Status/Hunk Indicators
    "plugins.terminal",         -- Togglable floating terminal window
    "plugins.whichkey",         -- Show pending keybinds
    "plugins.bufferline",       -- Show buffers in the tab line at top.
}

local failures = {}

for _, module in ipairs(plugins) do
    local ok, err = pcall(require, module)
    if not ok then
        failures[#failures + 1] = string.format("%s: %s", module, err)
    end
end

if #failures > 0 then
    local msg = "Failed to load:\n- " .. table.concat(failures, "\n- ")
    vim.notify(msg, vim.log.levels.ERROR)
end
