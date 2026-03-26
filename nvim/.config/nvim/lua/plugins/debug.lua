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
        -- "leoluz/nvim-dap-go",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        dap.adapters.codelldb = {
            type = "server",
            port = "${port}",
            executable = {
                command = "codelldb",
                args = { "--port", "${port}" },
            },
        }

        dap.configurations.zig = {
            {
                name = "Launch",
                type = "codelldb",
                request = "launch",
                program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
            },
        }

        require("mason-nvim-dap").setup({
            -- Makes a best effort to use reasonable defaults
            automatic_setup = false,
            automatic_installation = false,

            -- Optional: provide additional config to the handlers,
            -- see mason-nvim-dap README for more information
            handlers = {
                zig = function(config)
                    config.adapters = {
                        name = "Launch",
                        type = "codelldb",
                        request = "launch",
                        program = "${workspaceFolder}/zig-out/bin/${workspaceFolderBasename}",
                        cwd = "${workspaceFolder}",
                        stopOnEntry = false,
                        args = {},
                    }
                    require("mason-nvim-dap").default_setup(config)
                end,
            },
            ensure_installed = {
                -- "delve", -- Go (https://github.com/go-delve/delve)
            },
        })

        -- Basic debugging keymaps
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
        vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
        vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
        vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
        vim.keymap.set("n", "<F4>", dap.restart, { desc = "Debug: Restart" })
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

        -- Dap UI setup
        -- see |:h nvim-dap-ui|
        dapui.setup()

        -- Toggle to see last session result.
        -- Can't see session output in case of unhandled exception without this.
        vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close

        -- Golang
        -- require("dap-go").setup()
    end,
}
