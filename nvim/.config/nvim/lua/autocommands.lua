-- Highlight on yank
-- See `:h vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Sort Tailwind CSS classes on save
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.cmd("TailwindSort")
    end,
    pattern = "*.css,*.html,*.js,*.jsx,*.ts,*.tsx,*.vue,*.svelte",
})
