-- debug.lua
--
-- Uses the DAP plugin for debugging.
--
-- Was setup primarily on configuring the debugger for Go
return {
    -- This file is required in the plugins chunk,
    -- So Lazy will read this line.
    'mfussenegger/nvim-dap',
    dependencies = {
        'rcarriga/nvim-dap-ui',
        'williamboman/mason.nvim',
        'jay-babu/mason-nvim-dap.nvim',
        -- Add debuggers here
        'leoluz/nvim-dap-go',
    },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'

        require('mason-nvim-dap').setup {
            -- Makes a best effort to setup the various debuggers with
            -- reasonable debug configurations
            automatic_setup = true,

            -- Additional configuration to the handlers goes here.
            -- See mason-nvim-dap README for more information
            handlers = {},
            ensure_installed = {
                -- debuggers that you want.
                'delve',
            },
        }

        -- Basic debugging keymaps
        vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
        vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
        vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
        vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
        vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
        vim.keymap.set('n', '<leader>B', function()
            dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end, { desc = 'Debug: Set Breakpoint' })

        -- Dap UI setup
        -- :h nvim-dap-ui
        dapui.setup {
            -- Set icons to characters that are more likely to work in every terminal.
            -- Don't feel like these are good choices.
            icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
            controls = {
                icons = {
                    pause = '⏸',
                    play = '▶',
                    step_into = '⏎',
                    step_over = '⏭',
                    step_out = '⏮',
                    step_back = 'b',
                    run_last = '▶▶',
                    terminate = '⏹',
                    disconnect = '⏏',
                },
            },
        }

        -- Toggle to see last session result. Without this, you can't see
        -- session output in case of unhandled exception.
        vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

        dap.listeners.after.event_initialized['dapui_config'] = dapui.open
        dap.listeners.before.event_terminated['dapui_config'] = dapui.close
        dap.listeners.before.event_exited['dapui_config'] = dapui.close

        -- Install golang specific config
        require('dap-go').setup()
    end,
}
