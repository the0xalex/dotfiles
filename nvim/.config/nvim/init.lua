-- Currently running NVIM v0.10.0-dev-2469+gc538ec852
--    Built from source until neovim v0.10 is stable.
--    clone, then `make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX=$HOME/.local/bin install`

-- Set <space> as the leader key
-- Declare before plugins are required (or wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")
require("keymaps")
require("packages")
require("autocommands")
