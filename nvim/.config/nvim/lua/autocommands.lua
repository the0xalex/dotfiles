-- Briefly highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
})

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

        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end

        if is_mini_extra_loaded then
            -- To jump back, press <c-t>.
            map("gd", lsp_picker("declaration"), "[G]oto [d]eclaration")
            map("gD", lsp_picker("definition"), "[G]oto [D]efinition")
            map("gr", lsp_picker("references"), "[G]oto [r]eferences")
            map("gT", lsp_picker("type_definition"), "[G]oto [T]ype Definition")
        end
        -- Rename the variable under your cursor
        -- Most Language Servers support renaming across files, etc.
        map("<leader>lr", vim.lsp.buf.rename, "[L]SP [R]ename")
        map("<leader>la", vim.lsp.buf.code_action, "[L]SP Code [A]ction")

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
