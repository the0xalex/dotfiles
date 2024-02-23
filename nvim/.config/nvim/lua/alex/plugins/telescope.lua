local M = {}
-- Configure Telescope
-- See `:h telescope` and `:h telescope.setup()`
local actions = require("telescope.actions")
local icons = require("alex.icons").ui

M.telescope = {
    defaults = {
        prompt_prefix = icons.Telescope .. " ",
        selection_caret = icons.Forward .. " ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = nil,
        layout_strategy = nil,
        layout_config = {},
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-c>"] = actions.close,
                ["<C-n>"] = actions.cycle_history_next,
                ["<C-p>"] = actions.cycle_history_prev,
                ["<C-q>"] = function (...)
                    actions.smart_send_to_qflist(...)
                    actions.open_qflist(...)
                end,
                ["<CR>"] = actions.select_default,
            },
            n = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["j"] = actions.cycle_history_next,
                ["k"] = actions.cycle_history_prev,
                ["<C-q>"] = function (...)
                    actions.smart_send_to_qflist(...)
                    actions.open_qflist(...)
                end,
            },
        },
        file_ignore_patterns = {},
        path_display = { "smart" },
        winblend = 0,
        border = {},
        borderchars = nil,
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    },
    pickers = {
        builtin = {},
        find_files = {             -- Lists files in your cwd, respects .gitignore
            hidden = true,
        },
        live_grep = {              -- Regular interactive grep.  Uses `ripgrep`.
            only_sort_text = true, -- don't include the filename in the search results
        },
        grep_string = {            -- grep the selection or string under cursor in cwd
            only_sort_text = true,
        },
        keymaps = {},
        colorscheme = {
            enable_preview = true,
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        },
    },
}

function M.setup()
    local previewers = require "telescope.previewers"
    local sorters = require "telescope.sorters"

    M.telescope = vim.tbl_extend("keep", {
        file_previewer = previewers.vim_buffer_cat.new,
        grep_previewer = previewers.vim_buffer_vimgrep.new,
        qflist_previewer = previewers.vim_buffer_qflist.new,
        file_sorter = sorters.get_fuzzy_file,
        generic_sorter = sorters.get_generic_fuzzy_sorter,
    }, M.telescope)

    local telescope = require("telescope")

    local theme = require("telescope.themes")["get_" .. (M.telescope.theme or "")]
    if theme then
        M.telescope.defaults = theme(M.telescope.defaults)
    end

    telescope.setup(M.telescope)

    if package.loaded["project"] ~= nil then
        pcall(function ()
            require("telescope").load_extension("projects")
        end)
    end

    if M.telescope.extensions and M.telescope.extensions.fzf then
        pcall(function ()
            -- Enable telescope fzf native, if installed
            require("telescope").load_extension("fzf")
        end)
    end

    vim.keymap.set("n", "<leader>/", function ()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
        }))
    end, { desc = "[/] Fuzzily search in current buffer" })

    vim.keymap.set("n", "<leader>ss", require("telescope.builtin").builtin, { desc = "[S]earch [S]elect Telescope" })
    vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
    vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
    vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
    vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })
end

return M
