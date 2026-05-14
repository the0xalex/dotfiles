-- Set diagnostic configuration, mostly just for setting icons and
--   lsp virtual text

local icons = require("icons")
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
