-- Set <space> as the leader key
-- Declare before plugins are required (or wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")
require("packages")
require("autocommands")
