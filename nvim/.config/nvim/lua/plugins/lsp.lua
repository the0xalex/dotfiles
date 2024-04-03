-- LSP Configuration & Plugins
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        { "j-hui/fidget.nvim", opts = {} }, -- Useful status updates for LSP.
    },
    config = function()
        -- Run when a Language Server attaches to a particular buffer.
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("alex-lsp-attach", { clear = true }),
            callback = function(event)
                -- NOTE: Set maps here to apply to all the languages,
                -- rather than setting specific ones for each.
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- Jump to the definition of the word under your cursor.
                -- This is where a variable was first declared, or where a function is defined, etc.
                -- To jump back, press <c-t>.
                map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  In C this would take you to the header
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- Find references for the word under your cursor.
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                -- Jump to the implementation of the word under your cursor.
                -- Useful when a language can declare types without an actual implementation.
                map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                -- Jump to the type of the word under your cursor.
                -- When I want definition of *type* of the thing, not where it was *defined*.
                map("gT", require("telescope.builtin").lsp_type_definitions, "[T]ype Definition")

                -- Fuzzy find all the symbols in your current workspace
                -- Useful for avoiding comments.
                map("<leader>ls", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

                -- Rename the variable under your cursor
                -- Most Language Servers support renaming across files, etc.
                map("<leader>lr", vim.lsp.buf.rename, "[L]SP [R]ename")

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map("<leader>la", vim.lsp.buf.code_action, "[L]SP Code [A]ction")

                -- Opens a popup that displays documentation about the word under your cursor
                -- See `:h K` for why this keymap
                map("K", vim.lsp.buf.hover, "Hover Documentation")

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.server_capabilities.documentHighlightProvider then
                    -- Highlight references of the word under cursor when cursor rests
                    --    See `:h CursorHold` for information
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    -- Clear when cursor moves
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        -- By default, Neovim doesn't support everything that is in the LSP Specification.
        -- By adding nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        -- This creates new capabilities with nvim cmp, and then broadcasts that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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
            gopls = {},
            htmx = {},
            terraformls = {},
            -- pyright = {},
            rust_analyzer = {},
            --
            -- Some languages (like typescript) have entire language plugins that can be useful:
            --    https://github.com/pmizio/typescript-tools.nvim
            --
            -- For many setups, the LSP (`tsserver`) will work just fine
            -- tsserver = {},

            -- https://luals.github.io/wiki/settings/
            lua_ls = {
                -- cmd = {...},
                -- filetypes { ...},
                -- capabilities = {},
                settings = {
                    Lua = {
                        runtime = { version = "LuaJIT" },
                        workspace = {
                            checkThirdParty = false,
                            -- Tells lua_ls where to find all the Lua files that you have loaded
                            -- for your neovim configuration.
                            library = {
                                "${3rd}/luv/library",
                                unpack(vim.api.nvim_get_runtime_file("", true)),
                            },
                            -- If lua_ls is really slow on your computer, you can try this instead:
                            -- library = { vim.env.VIMRUNTIME },
                        },
                        completion = {
                            callSnippet = "Replace",
                        },
                        -- Ignore Lua_LS's noisy `missing-fields` warnings
                        diagnostics = { disable = { "missing-fields" } },
                    },
                },
            },
        }

        -- Ensure the servers and tools above are installed
        --
        -- To check the current status or manually install
        -- `:Mason`
        require("mason").setup()

        -- Add other tools (not just lsps) here for Mason to install
        -- so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "stylua", -- Lua formatter
        })
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        require("mason-lspconfig").setup({
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- Handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for tsserver)
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })

        -- Set diagnostic configuration, mostly for icons
        local loaded, icons = pcall(require, "icons")
        if not loaded then
            vim.notify("Icons not loaded, not setting diagnotic icons.")
        else
            local diagnostic_config = {
                signs = {
                    active = true,
                    values = {
                        { name = "DiagnosticSignError", text = icons.diagnostics.Error },
                        { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
                        { name = "DiagnosticSignHing", text = icons.diagnostics.Hint },
                        { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
                    },
                },
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

            ---@diagnostic disable-next-line: param-type-mismatch
            for _, sign in ipairs(vim.tbl_get(vim.diagnostic.config(), "signs", "values") or {}) do
                vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
            end
        end
    end,
}
