-- See `:h vim.opt`
local options = {
    backup = false,                          -- creates a backup file
    clipboard = "unnamedplus",               -- neovim to share the system clipboard `:h clipboard`
    cmdheight = 2,                           -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0,                        -- so that `` is visible in markdown files
    cursorline = false,                      -- highlight the current line
    expandtab = true,                        -- convert tabs to spaces
    fileencoding = "utf-8",                  -- the encoding written to a file (ascii would be better but that's not the future we got)
    foldmethod = "manual",                   -- set to "expr" for treesitter based folding
    foldexpr = "",                           -- set "nvim_treesitter#foldexpr()" for treesitter based folding
    guifont = "Hack Nerd Font",              -- if I ever use nvim gui apps I guess?
    hidden = true,                           -- keep multiple buffers open even when they are unmodified
    hlsearch = false,                        -- Don't highlight all matches on previous search pattern
    ignorecase = true,                       -- ignore case in search patterns
    incsearch = true,                        -- show matches for the pattern as it is being typed
    laststatus = 3,                          -- 3 = 'only' last window will 'always' have a status line
    list = false,                            -- Don't show whitespace chars `:h list`
    listchars = { tab = '» ', trail = '·', nbsp = '␣' }, -- set which chars used `:h listchars`
    mouse = "a",                             -- allow the mouse to be used in neovim
    number = true,                           -- set numbered lines
    numberwidth = 4,                         -- set number column width to 4 (default 4)
    pumheight = 10,                          -- pop up menu height
    relativenumber = true,                   -- set relative numbered lines
    ruler = false,                           -- redundant with lualine. line and column number of cursor
    scrolloff = 10,                          -- don't move cursor closer than this number of rows to bottom unless the bottom is EOF
    shiftwidth = 4,                          -- the number of spaces inserted for each indentation
    showcmd = false,                         -- redundant with lualine
    showmode = false,                        -- redundant with lualine
    showtabline = 2,                         -- always show tabs
    sidescrolloff = 8,                       -- horizontal version of scrolloff
    signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
    smartcase = true,                        -- \C or capital in search string unsets `ignorecase`
    smartindent = true,                      -- make indenting smarter again
    splitbelow = true,                       -- force all horizontal splits to go below current window
    splitright = true,                       -- force all vertical splits to go to the right of current window
    swapfile = false,                        -- creates a swapfile
    tabstop = 4,                             -- insert 2 spaces for a tab
    termguicolors = true,                    -- set term gui colors (most terminals support this)
    timeoutlen = 400,                        -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true,                         -- enable persistent undo
    updatetime = 100,                        -- faster completion (4000ms default)
    wrap = false,                            -- display lines as one long line
    writebackup = false,                     -- if a file is being edited by another program, do not allow editing
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

vim.opt.spelllang:append("cjk")                            -- disable spellchecking for asian characters
vim.opt.shortmess:append({ W = true, I = true, C = true }) -- don't show redundant messages from ins-completion-menu
vim.opt.isfname:append("@-@")                              -- allow @ in filenames
vim.opt.whichwrap:append("<,>,[,],h,l")                    -- allow these keys to go to next line if at beginning/end of line in n mode
