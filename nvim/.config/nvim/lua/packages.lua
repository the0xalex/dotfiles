-- Bootstrap the "Lazy" pagage manager
--     1. Clones the package manager if necessary
--     2. Loads the package manager
--     3. Passes in the plugin table defined above for configuration
--     See https://github.com/folke/lazy.nvim
--     or `h: lazy.nvim.txt` (after install)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath) ---@diagnostic disable-line: undefined-field

local loaded, package_manager = pcall(require, "lazy")
if not loaded then
    vim.notify("Lazy package manager failed to load.  Fix that.")
    return
end

-- Any lua mod inside this setup table should return a lua table that
-- satisfies the Lazy package definition format
package_manager.setup({

    -- MARK: Tools -------------

    require("plugins.telescope"), -- King of Fuzzy Finding
    require("plugins.whichkey"), -- Show pending keybinds
    require("plugins.conform"), -- Autoformat
    require("plugins.treesitter"), -- Highlights and symantics
    require("plugins.terminal"), -- Togglable floating terminal window
    require("plugins.lsp"), -- Language Server stuff
    require("plugins.completion"), -- Autocompletion stuff
    require("plugins.debug"), -- Debugger config
    require("plugins.copilot"), -- Helpful with boilerplate

    -- MARK: Editing ------------

    { "numToStr/Comment.nvim", opts = {} }, -- "gc" and "gb" to toggle comment a line/block.
    require("plugins.mini"), -- surrounds, text objects

    -- MARK: UI -----------------

    require("plugins.dashboard"), -- Startup screen
    require("plugins.gitsigns"), -- Git Status/Hunk Indicators
    require("plugins.bufferline"), -- Show buffers in the tab line at top.
    require("plugins.statusline"), -- All statusline stuff
    require("plugins.cloak"), -- Hides values in .env files

    --[[ Colorschemes ]]
    -- Preview and select them with `:Telescope colorschemes`
    require("plugins.main_colors"), -- GOAT, my default
    { "folke/tokyonight.nvim" }, -- The OG that the GOAT was based-on
    { "rose-pine/neovim" }, -- I like this for some languages
    { "catppuccin/nvim" }, -- other people like this.
    { "lunarvim/darkplus.nvim" }, -- for kids who recently evolved past vscode (honestly very complete)

    --[[ Other Color Stuff ]]
    require("plugins.nvim_colorizer"), -- Sets syntax hilight color for inline color literals
    require("plugins.todo_comments"), -- Parses out certain comments and sets hilight color
})
