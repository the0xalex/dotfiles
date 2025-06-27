-- Set <space> as the leader key
-- Declare before plugins are required (or wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

require("options")
require("keymaps")
require("packages")
require("autocommands")
