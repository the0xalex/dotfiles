return {
    "nvim-pack/nvim-spectre",
    build = false,
    cmd = "Spectre",
    opts = {
        open_cmd = "noswapfile vnew",
        replace_engine = {
            ["sed"] = {
                -- Need to specify for macOS
                cmd = "gsed",
            },
        },
    },
    -- stylua: ignore
    keys = {
        { "<leader>S", function() require("spectre").open() end, desc = "Replace in Files (Spectre)" },
    },
}
