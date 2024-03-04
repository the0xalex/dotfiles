return {
    "lunarvim/lunar.nvim",
    lazy = flase,
    priority = 1000,
    config = function()
        vim.cmd.colorscheme("lunar")
    end,
}
