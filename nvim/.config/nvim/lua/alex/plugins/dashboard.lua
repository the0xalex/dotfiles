local icons = require("alex.icons")

return {
    "goolord/alpha-nvim",
    config = function()
        local config
        local theme = require_safe("alpha.themes.dashboard")
        if theme ~= nil then
            theme.section.header.val = {
                [[  █████╗ ██╗     ███████╗██╗   ██╗        ██╗   ██╗██╗███╗   ███╗]],
                [[ ██╔══██╗██║     ██╔════╝╚██  ██╔╝        ██║   ██║██║████╗ ████║]],
                [[ ███████║██║     █████╗   ╚████╔╝  ████╗  ██║   ██║██║██╔████╔██║]],
                [[ ██╔══██║██║     ██╔══╝   ██╔═██╗  ╚═══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║]],
                [[ ██║  ██║███████╗███████╗██╔╝ ╚██╗         ╚████╔╝ ██║██║ ╚═╝ ██║]],
                [[ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝   ╚═╝          ╚═══╝  ╚═╝╚═╝     ╚═╝]],
            }
            theme.section.footer.val = { "[ " .. user_name .. " ]" }
            theme.section.buttons.val = {
                theme.button("f", icons.ui.FindFile .. "  Find File", "<cmd>Telescope find_files<cr>"),
                theme.button("n", icons.ui.NewFile .. "  New File", "<cmd>ene!<cr>"),
                theme.button("p", icons.ui.Project .. "  Projects ", "<cmd>Telescope projects<cr>"),
                theme.button("r", icons.ui.History .. "  Recent files", ":Telescope oldfiles <cr>"),
                theme.button("t", icons.ui.FindText .. "  Find Text", "<cmd>Telescope live_grep<cr>"),
                theme.button(
                    "c",
                    icons.ui.Gear .. "  Configuration",
                    "<cmd>edit " .. join_paths(alex_config_root, "init.lua") .. " <cr>"
                ),
                theme.button("q", icons.ui.Close .. "  Quit", "<cmd>quit<cr>"),
            }
            config = theme.config
        end
        require("alpha").setup(config)
    end,
    event = "VimEnter",
}
