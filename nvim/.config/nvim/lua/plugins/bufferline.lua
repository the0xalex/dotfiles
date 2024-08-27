-- see https://github.com/akinsho/bufferline.nvim
return {
    "akinsho/bufferline.nvim",
    version = "*",
    opts = {
        options = {
            get_element_icon = function(element)
                if not _G.MiniIcons then ---@diagnostic disable-line: undefined-field
                    return
                end
                local icon, hl = require("mini.icons").get("filetype", element.filetype)
                return icon, hl
            end,
        },
    },
}
