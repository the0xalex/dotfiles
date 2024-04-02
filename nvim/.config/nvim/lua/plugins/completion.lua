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
                    -- For tailwind colors
                    local utils = require("tailwind-tools.utils")
                    local doc = entry.completion_item.documentation
                    if vim_item.kind == "Color" and doc then
                        local content = type(doc) == "string" and doc or doc.value
                        local base, _, _, _r, _g, _b = 10, content:find("rgba?%((%d+), (%d+), (%d+)")
                        if not _r then
                            base, _, _, _r, _g, _b = 16, content:find("#(%x%x)(%x%x)(%x%x)")
                        end
                        if _r then
                            local r, g, b = tonumber(_r, base), tonumber(_g, base), tonumber(_b, base)
                            vim_item.kind_hl_group = utils.set_hl_from(r, g, b, "foreground")
                        end
                    end

                    -- Set my icons
                    vim_item.kind = icons.kind[vim_item.kind]
                    if entry.source.name == "copilot" then
                        vim_item.kind = icons.git.Octoface
                    end
                    vim_item.menu = source_names[entry.source.name]
                    vim_item.dup = duplicates[entry.source.name] or 0

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
