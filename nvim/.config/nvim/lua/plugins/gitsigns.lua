local icons = require("icons")
return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
        signs = {
            add = {
                hl = "GitSignsAdd",
                text = icons.ui.BoldLineLeft,
                numhl = "GitSignsAddNr",
                linehl = "GitSignsAddLn",
            },
            change = {
                hl = "GitSignsChange",
                text = icons.ui.BoldLineLeft,
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
            delete = {
                hl = "GitSignsDelete",
                text = icons.ui.Triangle,
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            topdelete = {
                hl = "GitSignsDelete",
                text = icons.ui.Triangle,
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            changedelete = {
                hl = "GitSignsChange",
                text = icons.ui.BoldLineLeft,
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
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
    },
    -- TODO: add to whichkey?
    init = function()
        vim.keymap.set(
            "n",
            "<leader>gl",
            "<cmd>lua require('gitsigns').blame_line()<cr>",
            { desc = "[G]it - show [l]ine blame", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<leader>gp",
            "<cmd>lua require('gitsigns').preview_hunk()<cr>",
            { desc = "[G]it - [p]review hunk", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<leader>gs",
            "<cmd>lua require('gitsigns').stage_hunk()<cr>",
            { desc = "[G]it - [s]tage hunk", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<leader>gr",
            "<cmd>lua require('gitsigns').reset_hunk()<cr>",
            { desc = "[G]it - [r]eset hunk", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<leader>gR",
            "<cmd>lua require('gitsigns').reset_buffer()<cr>",
            { desc = "[G]it - [R]eset the whole buffer", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<leader>gd",
            "<cmd>Gitsigns diffthis HEAD<cr>",
            { desc = "[G]it - Diff", noremap = true, silent = true }
        )
    end,
}
