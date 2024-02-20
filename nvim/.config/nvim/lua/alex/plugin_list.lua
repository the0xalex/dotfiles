return {
    "nvim-lua/plenary.nvim", -- The best lua helper library
    "folke/zen-mode.nvim",   -- Mostly for screen sharing

    -- NOTE: LSP

    "williamboman/mason.nvim",           -- lsp manager
    "williamboman/mason-lspconfig.nvim", -- bridge from mason to nvim-lspconfig
    "neovim/nvim-lspconfig",             -- collection of default lsp configs
    "j-hui/fidget.nvim",                 -- display for lsp events
    "folke/neodev.nvim",                 -- lua lsp extras for neovim dev
    "folke/which-key.nvim",              -- show pending keybinds

    -- NOTE: Colors
    --
    -- schemes
    {
        "lunarvim/lunar.nvim", -- GOAT, my default
        config = function()
            vim.cmd("colorscheme lunar")
        end,
    },
    { "rose-pine/neovim", name = "rose-pine", lazy = true }, -- I like this for some languages
    { "catppuccin/nvim", name = "catppuccin", lazy = true }, -- other people like this.
    { "lunarvim/darkplus.nvim", lazy = true }, -- for kids who recently evolved past vscode (honestly very complete)
    -- other color related things
    {
        -- Highlight inline color codes with the color.
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup(
                { "astro", "css", "scss", "html", "jsx", "tsx", "javascript", "typescriptreact" },
                {
                    RGB = true,      -- #RGB hex codes
                    RRGGBB = true,   -- #RRGGBB hex codes
                    RRGGBBAA = true, -- #RRGGBBAA hex codes
                    rgb_fn = true,   -- CSS rgb() and rgba() functions
                    hsl_fn = true,   -- CSS hsl() and hsla() functions
                    css = true,      -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                    css_fn = true,   -- Enable all CSS *functions*: rgb_fn, hsl_fn
                }
            )
        end,
    },
    {
        -- Parses out labelled comments and colizes the block.
        "folke/todo-comments.nvim",
        opts = {
            keywords = {
                MARK = { icon = " ", color = "warning" },
            },
        },
    },
    {
        -- Colorizes tailwindcss classes for colors.
        "roobert/tailwindcss-colorizer-cmp.nvim",
        config = function()
            require("tailwindcss-colorizer-cmp").setup({
                color_square_width = 2,
            })
        end,
    },

    -- Useless fun
    { "eandrju/cellular-automaton.nvim", lazy = true },

    -- Spectre
    -- Find / Replace
    {
        "windwp/nvim-spectre",
        event = "BufRead",
        config = function()
            require("spectre").setup({
                open_cmd = "noswapfile vnew",
            })
        end,
    },

    -- Comment
    { "numToStr/Comment.nvim", opts = {} }, -- "gc" to comment visual regions/lines

    -- Autocompletion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            {
                "L3MON4D3/LuaSnip",
                build = (function()
                    -- Build Step is needed for regex support in snippets
                    -- This step is not supported in many windows environments
                    -- Remove the below condition to re-enable on windows
                    if vim.fn.has("win32") == 1 then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
            },
            "saadparwaiz1/cmp_luasnip",

            -- Adds LSP completion capabilities
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",

            -- Adds a number of user-friendly snippets
            "rafamadriz/friendly-snippets",
        },
    },

    -- Git signs
    -- `:h gitsigns.txt`
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map({ "n", "v" }, "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Jump to next hunk" })

                map({ "n", "v" }, "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Jump to previous hunk" })

                -- Actions
                -- visual mode
                map("v", "<leader>hs", function()
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "stage git hunk" })
                map("v", "<leader>hr", function()
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "reset git hunk" })
                -- normal mode
                map("n", "<leader>hs", gs.stage_hunk, { desc = "git stage hunk" })
                map("n", "<leader>hr", gs.reset_hunk, { desc = "git reset hunk" })
                map("n", "<leader>hS", gs.stage_buffer, { desc = "git Stage buffer" })
                map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
                map("n", "<leader>hR", gs.reset_buffer, { desc = "git Reset buffer" })
                map("n", "<leader>hp", gs.preview_hunk, { desc = "preview git hunk" })
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = false })
                end, { desc = "git blame line" })
                map("n", "<leader>hd", gs.diffthis, { desc = "git diff against index" })
                map("n", "<leader>hD", function()
                    gs.diffthis("~")
                end, { desc = "git diff against last commit" })

                -- Toggles
                map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
                map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle git show deleted" })

                -- Text object
                map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
            end,
        },
    },

    -- Set lualine as statusline
    -- `:h lualine.txt`
    {
        "nvim-lualine/lualine.nvim",
        opts = {
            options = {
                icons_enabled = false,
                theme = "auto",
                component_separators = "|",
                section_separators = "",
            },
        },
    },

    -- Split (and join, though default join is all I use)
    -- `:h MiniSplitjoin`
    {
        "echasnovski/mini.splitjoin",
        version = false,
        opts = { mappings = { toggle = "S", split = "", join = "" } },
    },

    -- Align text in blocks
    {
        "echasnovski/mini.align",
        version = false,
        opts = {},
    },

    -- Indent scope
    {
        "echasnovski/mini.indentscope",
        version = false,
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            symbol = "▏",
            --symbol = "│",
            options = { try_as_border = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "help",
                    "alpha",
                    "dashboard",
                    "nvimtree",
                    "Trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- only loads if `make` is available.
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                -- NOTE: If you are having trouble with this installation,
                --       see the README for telescope-fzf-native
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        build = ":TSUpdate",
    },

    -- Dashboard
    require("alex.plugins.dashboard"),

    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        branch = "main",
        init = function()
            local term = require("alex.plugins.toggleterm")
            term:init()
        end,
        config = function()
            local term = require("alex.plugins.toggleterm")
            term:setup()
        end,
        cmd = {
            "ToggleTerm",
            "TermExec",
            "ToggleTermToggleAll",
            "ToggleTermSendCurrentLine",
            "ToggleTermSendVisualLines",
            "ToggleTermSendVisualSelection",
        },
        keys = require("alex.plugins.toggleterm").config.open_mapping,
    },

    require("alex.plugins.autoformat"),
    -- require("alex.plugins.debug"),
}
