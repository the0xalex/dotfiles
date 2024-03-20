local icons = require("icons")
local source_names = {
    nvim_lsp = "(LSP)",
    path = "(Path)",
    luasnip = "(Snippet)",
    copilot = "(Copilot)",
}
local duplicates = {
    buffer = 1,
    path = 1,
    nvim_lsp = 0,
    luasnip = 1,
}

return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        -- Snippet Engine & its associated nvim-cmp source
        {
            "L3MON4D3/LuaSnip",
            build = (function()
                -- Build Step is needed for regex support in snippets
                -- This step is not supported in many windows environments
                -- Remove the below condition to re-enable on windows
                if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
                    return
                end
                return "make install_jsregexp"
            end)(),
        },
        "saadparwaiz1/cmp_luasnip",

        -- Adds other completion capabilities.
        --  nvim-cmp does not ship with all sources by default. They are split
        --  into multiple repos for maintenance purposes.
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",

        -- Contains a variety of premade snippets.
        -- See https://github.com/rafamadriz/friendly-snippets
        {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
        { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} }, -- completion for tailwind colors requires tailwindLSP
    },
    config = function()
        -- See `:h cmp`
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        luasnip.config.setup({})

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            formatting = {
                fields = { "abbr", "kind", "menu" },
                format = function(entry, vim_item)
                    vim_item.kind = icons.kind[vim_item.kind]
                    if entry.source.name == "copilot" then
                        vim_item.kind = icons.git.Octoface
                    end
                    vim_item.menu = source_names[entry.source.name]
                    vim_item.dup = duplicates[entry.source.name] or 0

                    -- All of this `if` is for tailwind colorizer
                    if vim.tbl_contains({ "nvim_lsp" }, entry.source.name) then
                        local words = {}
                        for word in string.gmatch(vim_item.word, "[^-]+") do
                            table.insert(words, word)
                        end

                        local color_name, color_number
                        if
                            words[2] == "x"
                            or words[2] == "y"
                            or words[2] == "t"
                            or words[2] == "b"
                            or words[2] == "l"
                            or words[2] == "r"
                        then
                            color_name = words[3]
                            color_number = words[4]
                        else
                            color_name = words[2]
                            color_number = words[3]
                        end

                        if color_name == "white" or color_name == "black" then
                            local color
                            if color_name == "white" then
                                color = "ffffff"
                            else
                                color = "000000"
                            end
                            local hl_group = "lsp_documentColor_mf_" .. color
                            vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color, bg = "#" .. color })
                            vim_item.kind_hl_group = hl_group
                            vim_item.kind = string.rep(" ", 2) -- make the color square 2 chars wide
                            return vim_item
                        elseif #words < 3 or #words > 4 then
                            -- doesn't seem to be a tailwind color
                            return vim_item
                        end

                        if not color_name or not color_number then
                            return vim_item
                        end

                        local color_index = tonumber(color_number)
                        local tailwindcss_colors = require("tailwindcss-colorizer-cmp.colors").TailwindcssColors
                        if not tailwindcss_colors[color_name] then
                            return vim_item
                        end
                        if not tailwindcss_colors[color_name][color_index] then
                            return vim_item
                        end

                        local color = tailwindcss_colors[color_name][color_index]
                        local hl_group = "lsp_documentColor_mf_" .. color
                        vim.api.nvim_set_hl(0, hl_group, { fg = "#" .. color, bg = "#" .. color })
                        vim_item.kind_hl_group = hl_group
                        vim_item.kind = string.rep(" ", 2) -- make the color square 2 chars wide
                    end

                    return vim_item
                end,
            },

            -- I chose these mappings after reading `:h ins-completion`
            --
            -- No, but seriously. Read `:h ins-completion`.
            mapping = cmp.mapping.preset.insert({
                -- Select the [n]ext item
                ["<C-n>"] = cmp.mapping.select_next_item(),
                -- Select the [p]revious item
                ["<C-p>"] = cmp.mapping.select_prev_item(),

                -- Accept ([y]es) the completion.
                -- This will auto-import if your LSP supports it.
                -- This will expand snippets if the LSP sent a snippet.
                ["<C-y>"] = cmp.mapping.confirm({ select = true }),

                -- Manually trigger a completion from nvim-cmp.
                -- Generally you don't need this, because nvim-cmp will display
                -- completions whenever it has completion options available.
                ["<C-Space>"] = cmp.mapping.complete({}),

                -- Think of <c-l> as moving to the right of your snippet expansion.
                -- So if you have a snippet that's like:
                -- function $name($args)
                --     $body
                -- end
                --
                -- <c-l> will move to the right of each of the expansion locations.
                -- <c-h> is similar, except moving you backwards.
                ["<C-l>"] = cmp.mapping(function()
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    end
                end, { "i", "s" }),
                ["<C-h>"] = cmp.mapping(function()
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    end
                end, { "i", "s" }),
            }),
            sources = {
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "path" },
            },
            {
                { name = "buffer" },
            },
        })
    end,
}
