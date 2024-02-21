local M = {}

local components = require("alex.plugins.lualine.components")

M.log_enabled = false
function M:log(msg)
    if self.log_enabled then vim.notify(msg) end
end

M.config = {
    options = {
        theme = "auto",
        globalstatus = true,
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha" },
    },
    sections = {
        lualine_a = { components.mode },
        lualine_b = { components.branch },
        lualine_c = { components.diff },
        lualine_x = {
            components.diagnostics,
            components.lsp,
            components.filetype,
        },
        lualine_y = {},
        lualine_z = { components.location },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { components.filename },
        lualine_x = { components.location },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = nil,
    extensions = nil,
    on_config_done = nil,
}

function M:init()
    if #vim.api.nvim_list_uis() == 0 then
        M:log("headless mode detected, skipping running setup for lualine")
        return
    end

    local loaded, lualine = pcall(require, "lualine")
    if not loaded then
        return
    end

    lualine.setup(self.config)
end

return M
