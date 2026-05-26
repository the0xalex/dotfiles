-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
})

-- setup some plugin checks for conditional configuration
-- in the LSP autocommand

local is_mini_extra_loaded, mini_extra = pcall(require, "mini.extra")
local is_tw_loaded, _ = pcall(require, "tailwind-tools")

local lsp_picker = function(scope)
    return function()
        mini_extra.pickers.lsp({ scope = scope })
    end
end

-- Run when a Language Server attaches to a particular buffer.
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("alex-lsp-attach", { clear = true }),
    callback = function(event)
        local buffer = event.buf
        local client = assert(vim.lsp.get_client_by_id(event.data.client_id), "must have valid client")

        -- This section sets up keybinds that should only work when lsp is attached.
        -- TODO: Move these into the language server file.

        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        -- To jump back, press <c-t>.
        map("gd", [[:lua vim.lsp.buf.definition()<cr>zz]], "[G]oto [d]efinition")

        -- Rename the symbol under your cursor
        -- Most Language Servers support renaming across files, etc.
        map("<leader>lr", vim.lsp.buf.rename, "[L]SP [R]ename")

        -- Show code actions available from the lsp
        map("<leader>la", vim.lsp.buf.code_action, "[L]SP Code [A]ction")

        -- show a picker window for lsp locations
        if is_mini_extra_loaded then
            map("gD", lsp_picker("declaration"), "[G]oto [D]eclaration")
            map("gr", lsp_picker("references"), "[G]oto [r]eferences")
            map("gT", lsp_picker("type_definition"), "[G]oto [T]ype Definition")
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
            if is_tw_loaded then
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

-- if `nvim-treesitter` is installed,
--   autoinstalls treesitter parsers upon opening a filetype
--   that has a supported parser and we haven't installed it yet.
vim.api.nvim_create_autocmd("FileType", {
    callback = function(ev)
        -- grab the filetype's lang
        local lang = vim.treesitter.language.get_lang(ev.match)
        if not lang then
            return
        end

        -- Short circuit -
        --   `add` returns truthy if parser is already available on runtimepath.
        if vim.treesitter.language.add(lang) then
            vim.treesitter.start(ev.buf, lang)
            return
        end

        local is_nvts_loaded, nvts = pcall(require, "nvim-treesitter")
        if not is_nvts_loaded then
            return
        end

        local available_langs = nvts.get_available()
        local is_available = vim.tbl_contains(available_langs, lang)
        if is_available then
            nvts.install(lang):wait()
            vim.treesitter.start(ev.buf, lang)
            nvts.indentexpr()
        end
    end,
})
