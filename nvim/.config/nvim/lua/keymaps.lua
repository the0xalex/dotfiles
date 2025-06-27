-- Base keymaps

--[[ MARK: Insert Mode --]]

vim.keymap.set("i", "jk", "<esc>") -- my mode bounce

-- window nav using [option] + arrows
vim.keymap.set("i", "<m-Up>", "<c-\\><c-n><c-w>k")
vim.keymap.set("i", "<m-Down>", "<c-\\><c-n><c-w>j")
vim.keymap.set("i", "<m-Left>", "<c-\\><c-n><c-w>h")
vim.keymap.set("i", "<m-Right>", "<c-\\><c-n><c-w>l")

--[[ MARK: Normal Mode --]]

vim.keymap.set("n", "<s-h>", ":bprevious<CR>") -- load prev buffer
vim.keymap.set("n", "<s-l>", ":bnext<CR>") -- load next buffer
-- Keep cursor centered or stationary for:
vim.keymap.set("n", "J", "mzJ`z") -- joins
vim.keymap.set("n", "<c-d>", "<C-d>zz") -- half screen jump down
vim.keymap.set("n", "<c-u>", "<C-u>zz") -- half screen jump up
vim.keymap.set("n", "n", "nzzzv") -- next search result
vim.keymap.set("n", "N", "Nzzzv") -- prev search result
-- Window movement
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")
-- Resize window with ctl-arrows
vim.keymap.set("n", "<c-Up>", ":resize -2<cr>")
vim.keymap.set("n", "<c-Down>", ":resize +2<cr>")
vim.keymap.set("n", "<c-Left>", ":vertical resize -2<cr>")
vim.keymap.set("n", "<c-Right>", ":vertical resize +2<cr>")
-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Jump to previous [d]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Jump to next [d]iagnostic message" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- TODO: move to whichkey
vim.keymap.set("n", "<leader>q", ":lua vim.diagnostic.setloclist()<cr>", { desc = "Diagnostics in quickfix list" })
vim.keymap.set("n", "<leader>|", "<c-w>v", { desc = "Split window right" })
vim.keymap.set("n", "<leader>-", "<c-w>s", { desc = "Split window right" })
vim.keymap.set("n", "<leader>W", "<cmd>noautocmd w<cr>", { desc = "Write without formatting (noautocmd)" })
vim.keymap.set("n", "<leader>w", "<cmd>w!<cr>", { desc = "Write current buffer" })
vim.keymap.set("n", "<leader>bd", ":bd<cr>", { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>p", '"0p', { desc = "Put from 0 buffer" })
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "lsp format buffer" })
vim.keymap.set(
    "n",
    "<leader>r",
    [[:%s/\<<c-r><c-w>\>/<c-r><c-w>/gI<Left><Left><Left>]],
    { desc = "Edit All in Document", silent = false }
)
vim.keymap.set(
    "n",
    "<leader>x",
    ":execute '!cat % > ~/Desktop/' . expand('%:t:r') . '.txt'<cr>",
    { desc = "Export file to Desktop", silent = false }
)
-- requires bufferline
vim.keymap.set("n", "<leader>bl", ":BufferLineCloseRight<cr>", { desc = "Close [b]uffers to the right" })
vim.keymap.set("n", "<leader>bh", ":BufferLineCloseLeft<cr>", { desc = "Close [b]uffers to the left" })

--[[ MARK: Visual Mode --]]

-- Keep selection when indenting (recommend using mini.move instead)
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

--[[ MARK: Command Mode --]]

-- control key cursor nav in command line
vim.keymap.set("c", "<c-k>", "<Up>")
vim.keymap.set("c", "<c-j>", "<Down>")
vim.keymap.set("c", "<c-h>", "<Left>")
vim.keymap.set("c", "<c-l>", "<Right>")

--[[ MARK: Term Mode --]]

--vim.keymap.del("t", "<c-l>")
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Terminal Normal Mode" })
