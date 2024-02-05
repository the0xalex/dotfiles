local options = {
  backup = false, -- creates a backup file
  clipboard = "unnamedplus", -- allows neovim to access the system clipboard
  cmdheight = 2, -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0, -- so that `` is visible in markdown files
  expandtab = true, -- convert tabs to spaces
  fileencoding = "utf-8", -- the encoding written to a file
  hlsearch = false, -- Don't highlight all matches on previous search pattern
  incsearch = true, -- show matches for the pattern as it is being typed
  mouse = "a", -- allow the mouse to be used in neovim
  pumheight = 10, -- pop up menu height
  showmode = false, -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  smartindent = true, -- make indenting smarter again
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeoutlen = 400, -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true, -- enable persistent undo
  undodir = os.getenv("XDG_CACHE_HOME") .. "/nvim/undodir",
  updatetime = 100, -- faster completion (4000ms default)
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  shiftwidth = 4, -- the number of spaces inserted for each indentation
  tabstop = 4, -- insert 2 spaces for a tab
  cursorline = false, -- highlight the current line
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 2, -- set number column width to 2 {default 4}
  signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  scrolloff = 10, -- don't move cursor closer than this number of rows to bottom unless the bottom is EOF
  sidescrolloff = 8,
  guifont = "Hack Nerd Font", -- the font used in graphical neovim applications
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
vim.opt.shortmess:append({ W = true, I = true, C = true })
if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.splitkeep = "screen"
  vim.opt.shortmess:append({ C = true })
end
vim.opt.isfname:append("@-@") -- allow @ in filenames
vim.opt.whichwrap:append("<,>,[,],h,l") -- allow these keys to go to next line if at beginning/end of line in n mode

local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

keymap("n", "K", "O<Esc>", opts)

keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("i", "jk", "<ESC>", opts)
keymap("v", "p", '"_dP', opts)

-- Keep cursor centered or stationary for
keymap("n", "J", "mzJ`z", opts) -- joins
keymap("n", "<C-d>", "<C-d>zz", opts) -- half screen jump down
keymap("n", "<C-u>", "<C-u>zz", opts) -- half screen jump up
keymap("n", "n", "nzzzv", opts) -- next search result
keymap("n", "N", "Nzzzv", opts) -- prev search result
