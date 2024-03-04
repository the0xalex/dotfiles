return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = [[<c-\>]],
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2, -- the degree to darken to terminal color, default: 1 for dark backgrounds, 3 for light
            start_in_insert = true,
            insert_mappings = true, -- open mapping applies in insert mode
            persist_size = false,
            direction = "float", -- 'vertical' | 'horizontal' | 'window' | 'float',
            close_on_exit = true,
            shell = nil, -- default shell
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
        })
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({
            cmd = "lazygit",
            dir = "git_dir",
            direction = "float",
            float_opts = {
                border = "double",
            },
            -- function to run on opening the terminal
            on_open = function(term)
                vim.cmd("startinsert!")
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            end,
            -- function to run on closing the terminal
            on_close = function(term)
                vim.cmd("startinsert!")
            end,
        })

        function _lazygit_toggle()
            lazygit:toggle()
        end

        vim.keymap.set(
            "n",
            "<leader>gg",
            "<cmd>lua _lazygit_toggle()<cr>",
            { desc = "Run Lazygit in embedded terminal", noremap = true, silent = true }
        )
    end,
}
