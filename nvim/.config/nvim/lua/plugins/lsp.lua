-- LSP Configuration & Plugins
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for neovim
        "folke/neodev.nvim",
        "williamboman/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            opts = {
                integrations = {
                    ["mason-lspconfig"] = true,
                },
            },
        },
        { "j-hui/fidget.nvim", opts = {} }, -- Useful status updates for LSP.
        "b0o/SchemaStore.nvim", -- json Schema info
    },
    config = function()
        require("neodev").setup({
            -- library = {
            --   plugins = { "nvim-dap-ui" },
            --   types = true,
            -- },
        })
        -- LSP servers and clients are able to communicate to each other what features they support.
        -- By default, Neovim doesn't support everything that is in the LSP Specification.
        -- By adding nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        -- This creates new capabilities with nvim cmp, and then broadcasts that to the servers.
        local capabilities = nil
        if pcall(require, "cmp_nvim_lsp") then
            capabilities = require("cmp_nvim_lsp").default_capabilities()
        end

        local lspconfig = require("lspconfig")

        -- Enable the following language servers
        --
        --  See `:h lspconfig-all` for a list of all the pre-configured LSPs
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        local servers = {
            -- clangd = {},
            gopls = {
                settings = {
                    gopls = {
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                },
            },
            -- pyright = {},
            -- rust_analyzer = {},
            ts_ls = true,

            jsonls = {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            },

            -- https://luals.github.io/wiki/settings/
            lua_ls = true,

            -- https://github.com/GroovyLanguageServer/groovy-language-server
            -- groovyls = {
            --     filetypes = { "groovy" },
            --     --cmd = { groovyls },
            --     settings = {
            --         groovy = {
            --             classpath = {
            --                 "/Users/alex/Developer/work/z-web/source/app/.gradle/caches/",
            --                 "/Users/alex/Developer/work/z-web/source/app/build/classes/",
            --                 "/Users/alex/Developer/work/z-web/source/app/build/libs/",
            --                 "/Users/alex/.local/share/sdkman/candidates/grails/current/lib/",
            --             },
            --         },
            --     },
            -- },
        }

        -- Ensure the servers and tools above are installed
        --
        -- To check the current status or manually install
        -- `:Mason`
        require("mason").setup()
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "stylua", -- Lua formatter
        })

        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        for name, config in pairs(servers) do
            if config == true then
                config = {}
            end
            config = vim.tbl_deep_extend("force", {}, {
                capabilities = capabilities,
            }, config)

            lspconfig[name].setup(config)
        end

        local disable_semantic_tokens = {
            lua = true,
        }

        -- Run when a Language Server attaches to a particular buffer.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("alex-lsp-attach", { clear = true }),
            callback = function(event)
                local buffer = event.buf
                local client = assert(vim.lsp.get_client_by_id(event.data.client_id), "must have valid client")

                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- To jump back, press <c-t>.
                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                -- Find references for the word under your cursor.
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                -- Jump to the type of the word under your cursor.
                map("gT", require("telescope.builtin").lsp_type_definitions, "[T]ype Definition")
                -- Fuzzy find all symbols in your current workspace (avoids comments)
                map(
                    "<leader>ls",
                    require("telescope.builtin").lsp_dynamic_workspace_symbols,
                    "Search [W]orkspace [S]ymbols"
                )
                -- Rename the variable under your cursor
                -- Most Language Servers support renaming across files, etc.
                map("<leader>lr", vim.lsp.buf.rename, "[L]SP [R]ename")
                map("<leader>la", vim.lsp.buf.code_action, "[L]SP Code [A]ction")
                -- See `:h K` for why this keymap
                map("K", vim.lsp.buf.hover, "Hover Documentation")

                local filetype = vim.bo[buffer].filetype
                if disable_semantic_tokens[filetype] then
                    client.server_capabilities.semanticTokensProvider = nil
                end

                if client and client.server_capabilities.documentHighlightProvider then
                    -- Highlight references of the word under cursor when cursor rests
                    --    See `:h CursorHold` for information
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = buffer,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    -- Clear when cursor moves
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = buffer,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
                if client and client.name == "tailwindcss" then
                    -- Order tailwind classes
                    local loaded, _ = pcall(require, "tailwind-tools")
                    if not loaded then
                        vim.notify(
                            "Tailwind tools not loaded. either install it or setup prettier plugin to order tailwind classes"
                        )
                    else
                        vim.keymap.set(
                            "n",
                            "<leader>w",
                            ":TailwindSort<cr>:w<cr>",
                            { buffer = buffer, desc = "format tailwind classes and [w]rite" }
                        )
                    end
                end
            end,
        })

        -- Set diagnostic configuration, mostly for icons
        local loaded, icons = pcall(require, "icons")
        if not loaded then
            vim.notify("Icons not loaded, not setting diagnotic icons.")
        else
            local sev = vim.diagnostic.severity
            local severities = {
                [sev.ERROR] = { name = "ERROR", text = icons.diagnostics.Error, hl = "DiagnosticSignError" },
                [sev.WARN] = { name = "WARN", text = icons.diagnostics.Warning, hl = "DiagnosticSignWarn" },
                [sev.HINT] = { name = "HINT", text = icons.diagnostics.Hint, hl = "DiagnosticSignHint" },
                [sev.INFO] = { name = "INFO", text = icons.diagnostics.Information, hl = "DiagnosticSignInfo" },
            }
            local signs = {
                text = {},
                linehl = {},
                numhl = {},
            }

            for _, level in pairs(severities) do
                signs.text[sev[level.name]] = level.text
                signs.linehl[sev[level.name]] = level.hl
                signs.numhl[sev[level.name]] = level.hl
            end

            local diagnostic_config = {
                signs = signs,
                virtual_text = true,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            }
            vim.diagnostic.config(diagnostic_config)
        end
    end,
}
