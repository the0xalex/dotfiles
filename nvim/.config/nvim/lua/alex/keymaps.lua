local opts = { noremap = true, silent = true }
local map = vim.keymap.set

map("i", "jk", "<ESC>", opts)

--[[
keymap("n", "K", "O<Esc>", opts)

keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("i", "jk", "<ESC>", opts)
keymap("v", "p", '"_dP', opts)

-- Keep cursor centered or stationary for:
keymap("n", "J", "mzJ`z", opts) -- joins
keymap("n", "<C-d>", "<C-d>zz", opts) -- half screen jump down
keymap("n", "<C-u>", "<C-u>zz", opts) -- half screen jump up
keymap("n", "n", "nzzzv", opts) -- next search result
keymap("n", "N", "Nzzzv", opts) -- prev search result
--]]
