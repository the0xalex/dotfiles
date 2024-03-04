-- Base keymaps

--[[ MARK: Insert Mode --]]

vim.keymap.set("i", "jk", "<esc>") -- my mode bounce
vim.keymap.set("i", "<m-k>", "<esc>:m .-2<cr>==gi", { desc = "Move current line up" })
vim.keymap.set("i", "<m-j>", "<esc>:m .+1<cr>==gi", { desc = "Move current line down" })

-- window nav using [option] + arrows
vim.keymap.set("i", "<m-Up>", "<c-\\><c-n><c-w>k")
vim.keymap.set("i", "<m-Down>", "<c-\\><c-n><c-w>j")
vim.keymap.set("i", "<m-Left>", "<c-\\><c-n><c-w>h")
vim.keymap.set("i", "<m-Right>", "<c-\\><c-n><c-w>l")

--[[ MARK: Normal Mode --]]

vim.keymap.set("n", "<S-h>", ":bprevious<CR>") -- load prev buffer
vim.keymap.set("n", "<S-l>", ":bnext<CR>") -- load next buffer
-- Keep cursor centered or stationary for:
vim.keymap.set("n", "J", "mzJ`z") -- joins
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- half screen jump down
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- half screen jump up
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
vim.keymap.set("n", "<m-j>", ":m .+1<cr>==", { desc = "move line down" })
vim.keymap.set("n", "<m-k>", ":m .-2<cr>==", { desc = "move line up" })
-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Jump to previous [d]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Jump to next [d]iagnostic message" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- TODO: move to whichkey
vim.keymap.set("n", "<leader>e", ":lua vim.diagnostic.open_float()<cr>", { desc = "Open floating diagnostics" })
vim.keymap.set("n", "<leader>q", ":lua vim.diagnostic.setloclist()<cr>", { desc = "Diagnostics in quickfix list" })

--[[ MARK: Visual Mode --]]

-- Better indenting (keep selection)
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- d to black-hole register prior to paste
vim.keymap.set("v", "p", '"_dP')
vim.keymap.set("v", "gp", '"_dgP')

--[[ MARK: Visual Block Mode --]]

-- Better indenting (keep selection)
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")
-- d to black-hole register prior to paste
vim.keymap.set("x", "p", '"_dP')
vim.keymap.set("x", "<m-j>", ":m '>+1<cr>gv-gv") -- move block down
vim.keymap.set("x", "<m-k>", ":m '<-2<cr>gv-gv") -- move block up

--[[ MARK: Command Mode --]]

-- navigate tab completion with <c-j> and <c-k>
-- runs conditionally
vim.keymap.set("c", "<c-j>", 'pumvisible() ? "\\<c-n>" : "\\<c-j>"', { expr = true })
vim.keymap.set("c", "<c-k>", 'pumvisible() ? "\\<c-p>" : "\\<c-k>"', { expr = true })

--[[ MARK: Term Mode --]]

--vim.keymap.del("t", "<c-l>")
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Terminal Normal Mode" })
