local config = {
    ---set to false to disable project.nvim.
    active = true,

    on_config_done = nil,

    --- Manual mode won't automatically change your root directory.
    ---   If true, have to anually do so using `:ProjectRoot` command.
    manual_mode = false,

    --- Options = { "lsp", "pattern" },
    --- lsp detection is annoying with multiple langs in one project
    detection_methods = { "pattern" },

    -- All the patterns used to detect root dir, when **"pattern"** is in
    -- detection_methods.  Order matters.
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "pom.xml" },

    -- Table of lsp clients to ignore by name
    -- eg: { "efm", ... }
    ignore_lsp = {},

    -- Don't calculate root dir on specific directories
    -- Ex: { "~/.cargo/*", ... }
    exclude_dirs = {},

    -- Show hidden files in telescope
    show_hidden = false,

    -- When set to false, you will get a message when project.nvim changes your
    -- directory.
    silent_chdir = true,

    -- What scope to change the directory, valid options are
    -- * global (default)
    -- * tab
    -- * win
    scope_chdir = "global",

    --path to store the project history for use in telescope
    datapath = cache_dir,
}

return config
