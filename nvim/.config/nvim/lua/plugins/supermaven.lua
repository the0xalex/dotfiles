-- Better copilot.  Helpful with boilerplate
--   see https://github.com/supermaven-inc/supermaven-nvim
return {
    "supermaven-inc/supermaven-nvim",
    opts = {
        keymaps = {
            accept_suggestion = "<c-y>",
            clear_suggestion = "<c-]>",
            accept_word = "<c-cr>",
        },
        ignore_filetypes = {
            gitcommit = true,
            help = true,
            markdown = true,
        },
        disable_inline_completion = false,
        disable_keymaps = false,
    },
}
