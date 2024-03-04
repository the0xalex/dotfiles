local icons = require("icons").ui
local config_path = vim.fn.stdpath("config") .. "/init.lua"

return {
	"goolord/alpha-nvim",
	config = function()
		local config
		local theme = require("alpha.themes.dashboard")
		if theme ~= nil then
			theme.section.header.val = {
				[[  █████╗ ██╗     ███████╗██╗   ██╗        ██╗   ██╗██╗███╗   ███╗]],
				[[ ██╔══██╗██║     ██╔════╝╚██  ██╔╝        ██║   ██║██║████╗ ████║]],
				[[ ███████║██║     █████╗   ╚████╔╝  ████╗  ██║   ██║██║██╔████╔██║]],
				[[ ██╔══██║██║     ██╔══╝   ██╔═██╗  ╚═══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║]],
				[[ ██║  ██║███████╗███████╗██╔╝ ╚██╗         ╚████╔╝ ██║██║ ╚═╝ ██║]],
				[[ ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝   ╚═╝          ╚═══╝  ╚═╝╚═╝     ╚═╝]],
			}
			theme.section.footer.val = { "[ the0xalex ]" }
			theme.section.buttons.val = {
				theme.button("f", icons.FindFile .. "  Find File", ":Telescope find_files<cr>"),
				theme.button("n", icons.NewFile .. "  New File", ":ene!<cr>"),
				-- theme.button("p", icons.Project .. "  Projects ", "<cmd>Telescope projects<cr>"),
				theme.button("r", icons.History .. "  Recent files", ":Telescope oldfiles <cr>"),
				theme.button("t", icons.FindText .. "  Find Text", ":Telescope live_grep<cr>"),
				theme.button("c", icons.Gear .. "  Configuration", ":e " .. config_path .. "<cr>"),
				theme.button("q", icons.Close .. "  Quit", "<cmd>quit<cr>"),
			}
			config = theme.config
		end
		require("alpha").setup(config)
	end,
	event = "VimEnter",
}
