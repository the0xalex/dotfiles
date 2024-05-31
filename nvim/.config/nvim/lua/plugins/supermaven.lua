-- Better copilot.  Helpful with boilerplate
--   see https://github.com/supermaven-inc/supermaven-nvim
return {
    "supermaven-inc/supermaven-nvim",
    config = function()
        require("supermaven-nvim").setup({
            keymaps = {
                accept_suggestion = "C-y",
                clear_suggestion = "<C-]>",
            },
            ignore_filetypes = {
                gitcommit = true,
                help = true,
                markdown = true,
            },
            disable_inline_completion = false,
            disable_keymaps = false,
        })
    end,
}
