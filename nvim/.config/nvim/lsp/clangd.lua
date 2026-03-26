return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--offset-encoding=utf-16",
    },
    root_markers = { ".clangd", "compile_commands.json" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
}
