-- Lua plugin for copilot
--
-- Once plugin is running, run `:Copilot auth` to start the authentication process.
return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = { "InsertEnter" },
    config = function()
        require("copilot").setup({
            panel = {
                enabled = false,
                layout = {
                    position = "right",
                    ratio = 0.4,
                },
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = "<C-y>",
                    accept_word = false,
                    accept_line = "<C-CR>",
                    next = "<C-]>",
                    prev = "<C-[>",
                    dismiss = false,
                },
            },
            filetypes = {
                yaml = false,
                markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
        })
    end,
}
