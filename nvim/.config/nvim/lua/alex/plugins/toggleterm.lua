local M = {}

local term = require_safe("toggleterm.terminal").Terminal

M.config = {
    active = true,
    on_config_done = nil,
    size = 20,              -- size can be a number or function which is passed the current terminal
    open_mapping = [[<c-\>]],
    hide_numbers = true,    -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 1,     -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    persist_size = false,
    direction = "float",    -- direction = 'vertical' | 'horizontal' | 'window' | 'float',
    close_on_exit = true,   -- close the terminal window when the process exits
    shell = nil,            -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
        -- The border key is *almost* the same as 'nvim_win_open'
        -- see :h nvim_win_open for details on borders however
        -- the 'curved' border is a custom border type
        -- not natively supported but implemented in this plugin.
        -- border = 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
        border = "curved",
        -- width = <value>,
        -- height = <value>,
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },
    -- Add pre-configured executables
    -- { cmd, keymap, description, direction, size }
    -- alex.plugins.terminal.execs[#lvim.builtin.terminal.execs+1] = {"gdb", "tg", "GNU Debugger"}
    -- TODO: add mappings in which key and refactor to check for file context?
    execs = {
        { nil, "<M-1>", "Float Terminal", "float", nil },
        { nil, "<M-2>", "Vertical Terminal", "vertical", 0.4 },
    },
}

--- Get current buffer size
---@return {width: number, height: number}
local function get_buf_size()
    local cbuf = vim.api.nvim_get_current_buf()
    local bufinfo = vim.tbl_filter(
        function(buf)
            return buf.bufnr == cbuf
        end,
        vim.fn.getwininfo(vim.api.nvim_get_current_win()) ---@diagnostic disable-line: param-type-mismatch
    )[1]
    if bufinfo == nil then
        return { width = -1, height = -1 }
    end
    return { width = bufinfo.width, height = bufinfo.height }
end

--- Get the dynamic terminal size in cells
---@param direction number
---@param size number
---@return integer
local function get_dynamic_terminal_size(direction, size)
    size = size or M.config.size
    if direction ~= "float" and tostring(size):find(".", 1, true) then
        size = math.min(size, 1.0)
        local buf_sizes = get_buf_size()
        local buf_size = direction == "horizontal" and buf_sizes.height or buf_sizes.width
        return buf_size * size
    else
        return size
    end
end

function M:init()
    for i, exec in pairs(self.config.execs) do
        local direction = exec[4] or self.config.direction

        local opts = {
            cmd = exec[1] or self.config.shell or vim.o.shell,
            keymap = exec[2],
            label = exec[3],
            -- NOTE: can't seem to consistently bind id/count <= 9
            -- Might be weird interaction between vim window API and wezterm
            count = i + 100,
            direction = direction,
            size = function()
                ---@diagnostic disable-next-line: param-type-mismatch
                return get_dynamic_terminal_size(direction, exec[5])
            end,
        }

        M.add_exec(opts)
    end
end

M.setup = function()
    if term ~= nil then
        term.setup(M.config)
    end
end

M.add_exec = function(opts)
    local binary = opts.cmd:match("(%S+)")
    if vim.fn.executable(binary) ~= 1 then
        vim.notify("Skipping configuring executable " .. binary .. ". Please make sure it is installed properly.")
        return
    end

    vim.keymap.set({ "n", "t" }, opts.keymap, function()
        M._exec_toggle({ cmd = opts.cmd, count = opts.count, direction = opts.direction, size = opts.size() })
    end, { desc = opts.label, noremap = true, silent = true })
end

M._exec_toggle = function(opts)
    local _term = term:new({ cmd = opts.cmd, count = opts.count, direction = opts.direction })
    _term:toggle(opts.size, opts.direction)
end

-- TODO: This is a wip, the whole reason I made this mess of a file
M.lazygit_toggle = function()
    local lazygit = term:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        float_opts = {
            border = "none",
            width = 100000,
            height = 100000,
        },
        on_open = function(_)
            vim.cmd("startinsert!")
        end,
        on_close = function(_) end,
        count = 99,
    })
    lazygit:toggle()
end

return M
