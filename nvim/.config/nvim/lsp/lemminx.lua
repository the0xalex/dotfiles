---@type vim.lsp.Config
return {
    cmd = { "lemminx" },
    settings = {
        xml = {
            format = {
                enabled = true,
                insertSpaces = true,
                joinContentLines = true,
                preservedNewlines = 1,
                splitAttributes = "alignWithFirstAttr",
                tabSize = 4,
            },
        },
    },
    filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
    root_markers = { "manifest.json", ".git" },
}
