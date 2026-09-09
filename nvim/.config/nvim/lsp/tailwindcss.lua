---@type vim.lsp.Config
return {
    cmd = { "tailwindcss-language-server", "--stdio" },
    filetypes = { "templ", "html", "javascriptreact", "typescriptreact" },
    root_markers = { ".git" },
}
