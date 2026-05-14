-- I use this plugin to configure an overlay terminal window
--   which launches a new independent shell.
--
-- This enables me to use my <esc>,<esc> to treat the terminal
--   like a vim buffer so I can nav it easier.

vim.pack.add({
    "https://github.com/akinsho/toggleterm.nvim",
})

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
