-- Integrates a few git diff stuff into open buffers
--
-- Allows me to visually identify diff changes, hunks, staging, etc.
-- Also exposes some functions I bind for quick navigation and
--   introspection of diff status in open buffers

vim.pack.add({
    "https://github.com/lewis6991/gitsigns.nvim",
})

local icons = require("icons")

require("gitsigns").setup({
    signs = {
        add = { text = icons.ui.BoldLineLeft },
        change = { text = icons.ui.BoldLineLeft },
        delete = { text = icons.ui.Triangle },
        topdelete = { text = icons.ui.Triangle },
        changedelete = { text = icons.ui.BoldLineLeft },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
        interval = 1000,
        follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    status_formatter = nil, -- Use default
    update_debounce = 200,
    max_file_length = 40000,
    preview_config = {
        -- Options passed to nvim_open_win
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
})

local loaded, gitsigns = pcall(require, "gitsigns")
if not loaded then
    vim.notify("gitsigns missing; Not setting git buffer keymaps.")
else
    local map = function(key, action, desc)
        vim.keymap.set("n", key, action, { desc = desc, noremap = true, silent = true })
    end
    -- direction: string 'next' or 'prev'
    -- with_window: bool (show the hunk preview upon nav)
    local function move_to_git_text_object(direction, with_window)
        return function()
            gitsigns.nav_hunk(direction, { wrap = true, preview = with_window, target = "all" })
        end
    end
    map("<leader>gl", gitsigns.blame_line, "[g]it - Show [l]ine blame")
    map("<leader>gp", gitsigns.preview_hunk, "[g]it - [p]review hunk")
    map("<leader>gs", gitsigns.stage_hunk, "[g]it - [s]tage hunk")
    map("<leader>gr", gitsigns.reset_hunk, "[g]it - [r]eset hunk")
    map("<leader>gR", gitsigns.reset_buffer, "[g]it - [R]eset entire buffer")
    map("<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", "[g]it - [d]iff view of buffer")
    map("]g", move_to_git_text_object("next", false), "Move cursor to next git hunk")
    map("[g", move_to_git_text_object("prev", false), "Move cursor to previous git hunk")
    map("]G", move_to_git_text_object("next", true), "Next git hunk, show preview")
    map("[G", move_to_git_text_object("prev", true), "Previous git hunk, show preview")
end
