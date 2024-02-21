local M = {}

local icons = require_safe("alex.icons")
local ui_icons = icons.ui
local kind_icons = icons.kind

M.use_icons = true

M.config = {
    active = true,
    on_config_done = nil,
    winbar_filetype_exclude = {
        "help",
        "startify",
        "dashboard",
        "lazy",
        "neo-tree",
        "neogitstatus",
        "NvimTree",
        "Trouble",
        "alpha",
        "lir",
        "Outline",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "Jaq",
        "harpoon",
        "dap-repl",
        "dap-terminal",
        "dapui_console",
        "dapui_hover",
        "lab",
        "notify",
        "noice",
        "neotest-summary",
        "",
    },
    options = {
        icons = {
            Array = kind_icons.Array .. " ",
            Boolean = kind_icons.Boolean .. " ",
            Class = kind_icons.Class .. " ",
            Color = kind_icons.Color .. " ",
            Constant = kind_icons.Constant .. " ",
            Constructor = kind_icons.Constructor .. " ",
            Enum = kind_icons.Enum .. " ",
            EnumMember = kind_icons.EnumMember .. " ",
            Event = kind_icons.Event .. " ",
            Field = kind_icons.Field .. " ",
            File = kind_icons.File .. " ",
            Folder = kind_icons.Folder .. " ",
            Function = kind_icons.Function .. " ",
            Interface = kind_icons.Interface .. " ",
            Key = kind_icons.Key .. " ",
            Keyword = kind_icons.Keyword .. " ",
            Method = kind_icons.Method .. " ",
            Module = kind_icons.Module .. " ",
            Namespace = kind_icons.Namespace .. " ",
            Null = kind_icons.Null .. " ",
            Number = kind_icons.Number .. " ",
            Object = kind_icons.Object .. " ",
            Operator = kind_icons.Operator .. " ",
            Package = kind_icons.Package .. " ",
            Property = kind_icons.Property .. " ",
            Reference = kind_icons.Reference .. " ",
            Snippet = kind_icons.Snippet .. " ",
            String = kind_icons.String .. " ",
            Struct = kind_icons.Struct .. " ",
            Text = kind_icons.Text .. " ",
            TypeParameter = kind_icons.TypeParameter .. " ",
            Unit = kind_icons.Unit .. " ",
            Value = kind_icons.Value .. " ",
            Variable = kind_icons.Variable .. " ",
        },
        highlight = true,
        separator = " " .. ui_icons.ChevronRight .. " ",
        depth_limit = 0,
        depth_limit_indicator = "..",
    },
}

M.setup = function ()
    local status_ok, navic = pcall(require, "nvim-navic")
    if not status_ok then
        return
    end

    M.create_winbar()
    navic.setup(M.config.options)
end

M.get_filename = function ()
    local filename = vim.fn.expand("%:t")
    local extension = vim.fn.expand("%:e")
    local f = require("alex.helpers")

    if not f.isempty(filename) then
        local file_icon, hl_group
        local devicons_ok, devicons = pcall(require, "nvim-web-devicons")
        if M.use_icons and devicons_ok then
            file_icon, hl_group = devicons.get_icon(filename, extension, { default = true })

            if f.isempty(file_icon) then
                file_icon = icons.kind.File
            end
        else
            file_icon = ""
            hl_group = "Normal"
        end

        local buf_ft = vim.bo.filetype

        if buf_ft == "dapui_breakpoints" then
            file_icon = icons.ui.Bug
        end

        if buf_ft == "dapui_stacks" then
            file_icon = icons.ui.Stacks
        end

        if buf_ft == "dapui_scopes" then
            file_icon = icons.ui.Scopes
        end

        if buf_ft == "dapui_watches" then
            file_icon = icons.ui.Watches
        end

        -- if buf_ft == "dapui_console" then
        --   file_icon = icons.ui.DebugConsole
        -- end

        local navic_text = vim.api.nvim_get_hl(0, { name = "Normal" })
        vim.api.nvim_set_hl(0, "Winbar", { fg = navic_text.foreground })

        return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
    end
end

local get_gps = function ()
    local status_gps_ok, gps = pcall(require, "nvim-navic")
    if not status_gps_ok then
        return ""
    end

    local status_ok, gps_location = pcall(gps.get_location, {})
    if not status_ok then
        return ""
    end

    if not gps.is_available() or gps_location == "error" then
        return ""
    end

    if not require("alex.helpers").isempty(gps_location) then
        return "%#NavicSeparator#" .. icons.ui.ChevronRight .. "%* " .. gps_location
    else
        return ""
    end
end

local excludes = function ()
    return vim.tbl_contains(M.config.winbar_filetype_exclude or {}, vim.bo.filetype)
end

M.get_winbar = function ()
    if excludes() then
        return
    end
    local f = require("alex.helpers")
    local value = M.get_filename()

    local gps_added = false
    if not f.isempty(value) then
        local gps_value = get_gps()
        value = value .. " " .. gps_value
        if not f.isempty(gps_value) then
            gps_added = true
        end
    end

    if not f.isempty(value) and f.get_buf_option("mod") then
        -- TODO: replace with circle
        local mod = "%#LspCodeLens#" .. icons.ui.Circle .. "%*"
        if gps_added then
            value = value .. " " .. mod
        else
            value = value .. mod
        end
    end

    local num_tabs = #vim.api.nvim_list_tabpages()

    if num_tabs > 1 and not f.isempty(value) then
        local tabpage_number = tostring(vim.api.nvim_tabpage_get_number(0))
        value = value .. "%=" .. tabpage_number .. "/" .. tostring(num_tabs)
    end

    local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
    if not status_ok then
        return
    end
end

M.create_winbar = function ()
    vim.api.nvim_create_augroup("_winbar", {})
    vim.api.nvim_create_autocmd({
        "CursorHoldI",
        "CursorHold",
        "BufWinEnter",
        "BufFilePost",
        "InsertEnter",
        "BufWritePost",
        "TabClosed",
        "TabEnter",
    }, {
        group = "_winbar",
        callback = function ()
            if M.config.active then
                local status_ok, _ = pcall(vim.api.nvim_buf_get_var, 0, "lsp_floating_window")
                if not status_ok then
                    -- TODO:
                    require("alex.plugins.breadcrumbs").get_winbar()
                end
            end
        end,
    })
end

return M
