-- Currently running NVIM v0.10.0-dev-2469+gc538ec852
--    Built from source until neovim v0.10 is stable.
--    clone, then `make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local/bin install`

-- Set <space> as the leader key
-- Declare before plugins are required (or wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")

-- Handles packages
--     1. Clones the package manager if necessary.
--     2. Loads the package manager
--     3. Passes in the plugin table defined above for configuration.
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

-- Any lua mod inside this setup table should
-- return a Lazy package defintion table.
package_manager.setup({

	-- MARK: Tools -------------

	require("plugins.telescope"), -- King of Fuzzy Finding
	require("plugins.whichkey"), -- Show pending keybinds
	require("plugins.conform"), -- Autoformat
	require("plugins.treesitter"), -- Highlights and symantics
	require("plugins.terminal"),
	require("plugins.lsp"),
	require("plugins.completion"),

	-- MARK: Editing ------------

	{ "numToStr/Comment.nvim", opts = {} }, -- "gc" and "gb" to toggle comment a line/block.
	require("plugins.mini"), -- surrounds, text objects

	-- MARK: UI -----------------

	require("plugins.dashboard"), -- Startup screen
	require("plugins.gitsigns"), -- Git Status/Hunk Indicators
	require("plugins.bufferline"), -- Buffers in a "tab line" at top. kinda.

	--[[ Colorschemes ]]
	require("plugins.lunar_colorscheme"), -- GOAT, my default
	{ "folke/tokyonight.nvim", lazy = true }, -- The OG that the GOAT was based-on
	{ "rose-pine/neovim", name = "rose-pine", lazy = true }, -- I like this for some languages
	{ "catppuccin/nvim", name = "catppuccin", lazy = true }, -- other people like this.
	{ "lunarvim/darkplus.nvim", lazy = true }, -- for kids who recently evolved past vscode (honestly very complete)

	--[[ Other Color Stuff ]]
	require("plugins.nvim_colorizer"), -- Sets syntax hilight color for inline color literals
	require("plugins.todo_comments"), -- Parses out certain comments and sets hilight color
	{ "roobert/tailwindcss-colorizer-cmp.nvim" }, -- enables completion color for tailwind colors (NOTE: enable in cmp later)
})

-- Highlight on yank
-- See `:h vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})
