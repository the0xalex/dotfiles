-- Collection of small independantly loaded modules.
--   See https://github.com/echasnovski/mini.nvim
return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]parenthen
		--  - yinq - [Y]ank [I]nside [N]ext [']quote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })

		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()

		-- Split (and join, though default join is all I use)
		-- `:h MiniSplitjoin`
		require("mini.splitjoin").setup({
			mappings = { toggle = "S", split = "", join = "" },
		})

		require("mini.indentscope").setup({
			event = { "BufReadPre", "BufNewFile" },
			symbol = "▏",
			mappings = { -- set to empty string to disable
				-- Textobjects
				object_scope = "",
				object_scope_with_border = "",
				-- object_scope = "ii",
				-- object_scope_with_border = "ai",

				-- Motions (jump to respective border line; if not present - body line)
				goto_top = "[i",
				goto_bottom = "]i",
			},
			options = { try_as_border = true },
		})

		-- Simple and easy statusline.
		--   You could remove this setup call if you don't like it,
		--   and try some other statusline plugin
		require("mini.statusline").setup()
		MiniStatusline.section_location = function()
			return "%2l:%-2v"
		end
	end,
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = {
				"man",
				"help",
				"alpha",
				"dashboard",
				"nvimtree",
				"Trouble",
				"lazy",
				"mason",
				"notify",
				"toggleterm",
				"lazyterm",
			},
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
		})
	end,
}
