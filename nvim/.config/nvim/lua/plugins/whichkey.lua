-- Light interface to
--   show what hotkey options are available from a given key
--   show copy buffer contents

vim.pack.add({
    "https://github.com/folke/which-key.nvim",
})

require("which-key").setup()
