--- The 0xalex Config
--- prereqs:
---   - git
---   - neovim v0.10.0+
local M = {}

-- Make some globals
_G.require_clean = require("alex.helpers").require_clean
_G.require_safe = require("alex.helpers").require_safe
_G.reload = require("alex.helpers").reload
_G.join_paths = require("alex.helpers").join_paths

--- Settings to load
--- NOTE: These lua modules have an `:init` function by convention.
---@type (string)[]
local settings = {
    "options",
    "keymaps",
}

M.load_settings = function()
    for _, file in ipairs(settings) do
        local mod_name = "alex" .. "." .. file
        local mod = require_safe(mod_name)
        if mod ~= nil then mod:init() end
    end
end

--- Plugins to load
local plugins = require("alex.plugin_list")

--- Handles packages.
--- 1. Clones the package manager if necessary.
--- 2. Loads the package manager
--- 3. Passes in the plugin table defined above for configuration.
--- NOTE: https://github.com/folke/lazy.nvim
---@see Lazy or `h: lazy.nvim.txt` after install
M.load_plugins = function()
    local lazypath = join_paths(vim.fn.stdpath("data"), "lazy", "lazy.nvim")
    -- WARN: will fail if you don't have git installed.
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup(plugins)
end

function M:init()
    self.load_settings()
    self.load_plugins()

    -- Highlight on yank
    -- See `:h vim.highlight.on_yank()`
    local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
    vim.api.nvim_create_autocmd('TextYankPost', {
        callback = function()
            vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = '*',
    })
end

return M
