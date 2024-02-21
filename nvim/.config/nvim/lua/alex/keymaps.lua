local M = {}

M.log_enabled = false
function M:log(msg)
    if self.log_enabled then vim.notify(msg) end
end

local _opts = { noremap = true, silent = true }
local opts = {
    insert_mode = _opts,
    normal_mode = _opts,
    visual_mode = _opts,
    command_mode = _opts,
    visual_block_mode = _opts,
    operator_pending_mode = _opts,
    term_mode = { silent = true },
}

local modes = {
    insert_mode = "i",
    normal_mode = "n",
    term_mode = "t",
    visual_mode = "v",
    visual_block_mode = "x",
    command_mode = "c",
    operator_pending_mode = "o",
}

---Alex's keymaps in a neatly editable list of tables
---
---set a key to "false" to unset a default.
local maps = {
    insert_mode = {
        ["jk"] = "<esc>", -- my mode bounce
        ["<m-k>"] = { "<esc>:m .-2<cr>==gi", { desc = "Move current line up" } },
        ["<m-j>"] = { "<esc>:m .+1<cr>==gi", { desc = "Move current line down" } },
        -- arrow window nav
        ["<m-Up>"] = "<c-\\><c-n><c-w>k",
        ["<m-Down>"] = "<c-\\><c-n><c-w>j",
        ["<m-Left>"] = "<c-\\><c-n><c-w>h",
        ["<m-Right>"] = "<c-\\><c-n><c-w>l",
    },

    normal_mode = {
        ["<S-h>"] = ":bprevious<CR>", -- load prev buffer
        ["<S-l>"] = ":bnext<CR>",     -- load next buffer
        -- Keep cursor centered or stationary for:
        ["J"] = "mzJ`z",              -- joins
        ["<C-d>"] = "<C-d>zz",        -- half screen jump down
        ["<C-u>"] = "<C-u>zz",        -- half screen jump up
        ["n"] = "nzzzv",              -- next search result
        ["N"] = "Nzzzv",              -- prev search result
        -- Window movement
        ["<c-h>"] = "<c-w>h",
        ["<c-j>"] = "<c-w>j",
        ["<c-k>"] = "<c-w>k",
        ["<c-l>"] = "<c-w>l",
        -- Resize window with ctl-arrows
        ["<c-Up>"] = ":resize -2<cr>",
        ["<c-Down>"] = ":resize +2<cr>",
        ["<c-Left>"] = ":vertical resize -2<cr>",
        ["<c-Right>"] = ":vertical resize +2<cr>",
        ["<m-j>"] = ":m .+1<cr>==", -- move line down
        ["<m-k>"] = ":m .-2<cr>==", -- move line up
        -- Diagnostics
        ["[d"] = { ":lua vim.diagnostic.goto_prev()<cr>", { desc = "Jump to previous diagnostic message" } },
        ["]d"] = { ":lua vim.diagnostic.goto_next()<cr>", { desc = "Jump to next diagnostic message" } },
        -- TODO: move to whichkey
        ["<leader>e"] = { ":lua vim.diagnostic.open_float()<cr>", { desc = "Open floating diagnostics" } },
        ["<leader>q"] = { ":lua vim.diagnostic.setloclist()<cr>", { desc = "Diagnostics in quickfix list" } },
        ["<leader>gg"] = { "<cmd>lua require 'alex.plugins.toggleterm'.lazygit_toggle()<cr>", { desc = "Lazygit" } },
    },

    visual_mode = {
        -- Better indenting
        ["<"] = "<gv",
        [">"] = ">gv",
        ["p"] = "\"_dP",   -- d to black-hole register prior to paste
        ["gp"] = "\"_dgP", -- same, but leave cursor after pasted text
    },

    visual_block_mode = {
        -- Better indenting
        ["<"] = "<gv",
        [">"] = ">gv",
        ["p"] = "\"_dP",                -- d to black-hole register prior to paste
        ["<m-j>"] = ":m '>+1<cr>gv-gv", -- move block down
        ["<m-k>"] = ":m '<-2<cr>gv-gv", -- move block up
    },

    command_mode = {
        -- navigate tab completion with <c-j> and <c-k>
        -- runs conditionally
        ["<c-j>"] = { 'pumvisible() ? "\\<c-n>" : "\\<c-j>"', { expr = true } },
        ["<c-k>"] = { 'pumvisible() ? "\\<c-p>" : "\\<c-k>"', { expr = true } },
    },

    term_mode = {
        ["<c-l>"] = false,
        ["<esc><esc>"] = "<c-\\><c-n>", -- Enter Terminal Normal Mode
    },
}

---Unsets all keybindings defined in keymaps
---Not exported.  For debugging or whatever.
---@param keymaps table A list of mode tables (normal_mode, insert_mode, ..)
function M.clear(keymaps)
    for mode, mappings in pairs(keymaps) do
        local translated_mode = modes[mode] and modes[mode] or mode
        for key, _ in pairs(mappings) do
            -- looks like some shitty programmers might write plugins that override
            -- bindings that the user hasn't set yet
            if maps[mode][key] ~= nil or (maps[translated_mode] ~= nil and maps[translated_mode][key] ~= nil) then
                pcall(vim.api.nvim_del_keymap, translated_mode, key)
            end
        end
    end
end

---Load (or delete) key mappings for all provided modes
---@param keymaps table A list of key mappings for each mode
function M.load(keymaps)
    keymaps = keymaps or {}
    for mode, mapping_table in pairs(keymaps) do
        mode = modes[mode] or mode
        for k, v in pairs(mapping_table) do
            local default_opts = opts[mode] or _opts
            local item_opts = {}
            if type(v) == "table" then
                item_opts = v[2]
                v = v[1]
                for ik, iv in pairs(default_opts) do
                    item_opts[ik] = iv
                end
            else
                item_opts = default_opts
            end
            if v then
                M:log(
                    "mapping " ..
                    tostring(k) ..
                    " to " .. v ..
                    " for mode " ..
                    tostring(mode) ..
                    " with opts: " ..
                    vim.inspect(item_opts)
                )
                vim.keymap.set(mode, k, v, item_opts)
            else
                M:log("deleting " .. tostring(k) .. " for mode " .. tostring(mode))
                pcall(vim.api.nvim_del_keymap, mode, k)
            end
        end
    end
end

function M:init()
    self.load(maps)
end

return M
