-- Configures a top-bar which displays currently allocated file buffers

vim.pack.add({
    "https://github.com/akinsho/bufferline.nvim",
})

local loaded, bufferline = pcall(require, "bufferline")
if loaded then
    bufferline.setup({
        options = {
            get_element_icon = function(element)
                if not _G.MiniIcons then ---@diagnostic disable-line: undefined-field
                    return
                end
                local icon, hl = require("mini.icons").get("filetype", element.filetype)
                return icon, hl
            end,
        },
    })

    -- delete the buffers to the right or left, using vim motion directions
    --   will raise an exception if they aren't saved or whatever, aligned with global settings for that.
    vim.keymap.set("n", "<leader>bl", ":BufferLineCloseRight<cr>", { desc = "Close [b]uffers to the right" })
    vim.keymap.set("n", "<leader>bh", ":BufferLineCloseLeft<cr>", { desc = "Close [b]uffers to the left" })
end
