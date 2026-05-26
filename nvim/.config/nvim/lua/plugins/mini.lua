-- Collection of lightweight plugins that each do a specific thing.
--   I really like the way this guy writes plugins and the simplicity
--   of them.  Many of them replaced things I wrote myself in a bit more
--   robust implementation.
--
-- I pack add the whole collection for simplicity, but then only call
--   `setup` on the ones I actuallly use.

vim.pack.add({
    { src = "https://github.com/nvim-mini/mini.nvim", version = "stable" },
})

require("mini.icons").setup()
require("mini.completion").setup()

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]parenthen
--  - yinq - [Y]ank [I]nside [N]ext [']quote
--  - ci"  - [C]hange [I]nside ["]dquote
require("mini.ai").setup({ n_lines = 500 })

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()

-- Move text in any direction
--
-- This took the place of some custom mappings I was using prior.
--     Documenting here for reference in case I need to recreate them
--     in vimscript or remote or something
-- ```lua
-- vim.keymap.set("i", "<m-k>", "<esc>:m .-2<cr>==gi", { desc = "Move current line up" })
-- vim.keymap.set("i", "<m-j>", "<esc>:m .+1<cr>==gi", { desc = "Move current line down" })
-- vim.keymap.set("n", "<m-j>", ":m .+1<cr>==", { desc = "move line down" })
-- vim.keymap.set("n", "<m-k>", ":m .-2<cr>==", { desc = "move line up" })
-- vim.keymap.set("x", "<m-k>", ":m '<-2<cr>gv-gv", {desc = "move block up" })
-- vim.keymap.set("x", "<m-j>", ":m '>+1<cr>gv-gv", { desc = "move block down" })
-- ```
--
-- Default mappings
-- Visual mode
--   left = '<M-h>'
--   right = '<M-l>'
--   down = '<M-j>'
--   up = '<M-k>'
--
-- Normal mode
--   line_left = '<M-h>'
--   line_right = '<M-l>'
--   line_down = '<M-j>'
--   line_up = '<M-k>'
require("mini.move").setup()

-- Split (and join, though default join is all I use)
-- `:h MiniSplitjoin`
require("mini.splitjoin").setup({
    mappings = { toggle = "S", split = "", join = "" },
})

-- Navigate file system using column view (Miller columns) to display nested directories.
-- `:h MiniFiles`
local is_files_loaded, files = pcall(require, "mini.files")
if is_files_loaded then
    files.setup()
    local files_toggle = function()
        if not files.close() then
            files.open()
        end
    end

    local relative_files_toggle = function()
        if not files.close() then
            files.open(vim.api.nvim_buf_get_name(0))
        end
    end

    vim.keymap.set("n", "<leader>e", files_toggle, { desc = "[E]xplore Files" })
    vim.keymap.set("n", "<leader>E", relative_files_toggle, { desc = "[E]xplore at Relative Path" })
end

require("mini.indentscope").setup({
    event = { "BufReadPre", "BufNewFile" },
    symbol = "▏",
    mappings = {
        -- Textobjects
        -- set to empty string to disable
        -- object_scope = "",
        -- object_scope_with_border = "",
        object_scope = "ii",
        object_scope_with_border = "ai",

        -- Motions (jump to scope line top/bottom)
        goto_top = "[i",
        goto_bottom = "]i",
    },
    options = { try_as_border = true },
})

-- Fuzzy picker
-- `:h MiniPick-overview`
local is_pick_loaded, pick = pcall(require, "mini.pick")
if is_pick_loaded then
    pick.setup()
    vim.keymap.set("n", "<leader>sf", pick.builtin.files, { desc = "[S]earch Files in Project" })
    vim.keymap.set("n", "<leader>sg", pick.builtin.grep_live, { desc = "[S]earch Files in Project" })
end

-- Used in LSP autocommand for keymaps related to opening LSP based picker windows
require("mini.extra").setup()
