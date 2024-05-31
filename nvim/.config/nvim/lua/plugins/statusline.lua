local window_width_limit = 100

local conditions = {
    buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
    end,
    hide_in_width = function()
        return vim.o.columns > window_width_limit
    end,
}

local colors = {
    bg = "#202328",
    fg = "#bbc2cf",
    yellow = "#ECBE7B",
    cyan = "#008080",
    darkblue = "#081633",
    green = "#98be65",
    orange = "#FF8800",
    violet = "#a9a1e1",
    magenta = "#c678dd",
    purple = "#c678dd",
    blue = "#51afef",
    red = "#ec5f67",
}

local icons = require("icons")

local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed,
        }
    end
end

-- Trying a thing
-- local branch = icons.git.Branch
local branch = "%#SLGitIcon#" .. icons.git.Branch .. "%*" .. "%#SLBranchName#"

-- This is a collection of functions that compute a component of lualine
-- status for something or other. Some I'm messing with, some are borrowed.
-- Apologies for any lack of attribution.
--
-- Probably a lot of them taken from or inspired by the very configurable
-- base options in lualine's repo:
-- `https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#changing-components-in-lualine-sections`
local components = {
    mode = {
        "mode",
        padding = 1,
        color = {},
        cond = nil,
    },

    branch = {
        "b:gitsigns_head",
        icon = branch,
        color = { gui = "bold" },
    },

    filename = {
        "filename",
        color = {},
        cond = nil,
    },

    diff = {
        "diff",
        source = diff_source,
        symbols = {
            added = icons.git.LineAdded .. " ",
            modified = icons.git.LineModified .. " ",
            removed = icons.git.LineRemoved .. " ",
        },
        padding = { left = 2, right = 1 },
        diff_color = {
            added = { fg = colors.green },
            modified = { fg = colors.yellow },
            removed = { fg = colors.red },
        },
        cond = nil,
    },

    diagnostics = {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        symbols = {
            error = icons.diagnostics.BoldError .. " ",
            warn = icons.diagnostics.BoldWarning .. " ",
            info = icons.diagnostics.BoldInformation .. " ",
            hint = icons.diagnostics.BoldHint .. " ",
        },
    },

    treesitter = {
        function()
            return icons.ui.Tree
        end,
        color = function()
            local buf = vim.api.nvim_get_current_buf()
            local ts = vim.treesitter.highlighter.active[buf]
            return { fg = ts and not vim.tbl_isempty(ts) and colors.green or colors.red }
        end,
        cond = conditions.hide_in_width,
    },

    lsp = {
        function()
            local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
            if #buf_clients == 0 then
                return "LSP Inactive"
            end

            local buf_client_names = {}
            local supermaven_active = false

            -- add client
            for _, client in pairs(buf_clients) do
                if client.name ~= "Supermaven" then
                    table.insert(buf_client_names, client.name)
                end

                if client.name == "Supermaven" then
                    supermaven_active = true
                end
            end

            local unique_client_names = table.concat(buf_client_names, ", ")
            local language_servers = string.format("[%s]", unique_client_names)

            if supermaven_active then
                language_servers = language_servers .. "%#SLCopilot#" .. " " .. icons.misc.Robot .. "%*"
            end

            return language_servers
        end,
        color = { gui = "bold" },
        cond = conditions.hide_in_width,
    },

    location = { "location" },

    progress = {
        "progress",
        fmt = function()
            return "%P/%L"
        end,
        color = {},
    },

    spaces = {
        function()
            local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
            return icons.ui.Tab .. " " .. shiftwidth
        end,
        padding = 1,
    },

    encoding = {
        "o:encoding",
        fmt = string.upper,
        color = {},
        cond = conditions.hide_in_width,
    },

    filetype = {
        "filetype",
        cond = nil,
        padding = 1,
    },
}

return {
    "nvim-lualine/lualine.nvim",
    opts = {
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
    },
}
