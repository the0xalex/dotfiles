local icons = require("icons")
return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
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
    },
    -- TODO: add to whichkey?
    init = function()
        vim.keymap.set(
            "n",
            "<leader>gl",
            "<cmd>lua require('gitsigns').blame_line()<cr>",
            { desc = "[G]it - Show [l]ine blame", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<leader>gp",
            "<cmd>lua require('gitsigns').preview_hunk()<cr>",
            { desc = "[G]it - [P]review hunk", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<leader>gs",
            "<cmd>lua require('gitsigns').stage_hunk()<cr>",
            { desc = "[G]it - [S]tage hunk", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "<leader>gr",
            "<cmd>lua require('gitsigns').reset_hunk()<cr>",
            { desc = "[G]it - [R]eset hunk", noremap = true, silent = true }
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
        vim.keymap.set(
            "n",
            "]g",
            "<cmd>Gitsigns next_hunk HEAD<cr>",
            { desc = "Next git hunk", noremap = true, silent = true }
        )
        vim.keymap.set(
            "n",
            "[g",
            "<cmd>Gitsigns prev_hunk HEAD<cr>",
            { desc = "Previous git hunk", noremap = true, silent = true }
        )
    end,
}
