-- Sets up nvim as a client for DAP.

return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "nvim-neotest/nvim-nio",
        -- Creates a debug UI
        "rcarriga/nvim-dap-ui",

        -- Use mason for managing debug adapters
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",

        -- Add debuggers (DAP servers/adapters) below
        "leoluz/nvim-dap-go",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("mason-nvim-dap").setup({
            -- Makes a best effort to use reasonable defaults
            automatic_setup = true,

            -- Optional: provide additional config to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {},
            ensure_installed = {
                "delve", -- Go (https://github.com/go-delve/delve)
            },
        })

        -- Basic debugging keymaps
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
        vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
        vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
        vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>B", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Debug: Set Breakpoint" })

        -- Dap UI setup
        -- see |:h nvim-dap-ui|
        dapui.setup({
            icons = {
                expanded = "",
                collapsed = "",
                current_frame = "󰀘",
            },

            controls = {
                icons = {
                    pause = "⏸",
                    play = "▶",
                    step_into = "",
                    step_over = "",
                    step_out = "",
                    step_back = "",
                    run_last = "",
                    terminate = "⏹",
                    disconnect = "⏏",
                },
            },
        })

        -- Toggle to see last session result.
        -- Can't see session output in case of unhandled exception without this.
        vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        -- Golang
        require("dap-go").setup()
    end,
}
