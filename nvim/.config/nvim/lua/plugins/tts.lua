local M = {}

-- ---------------------------------------------------------------------
-- Paths
-- ---------------------------------------------------------------------

local cache_dir = vim.fn.stdpath("cache") .. "/tts-editor"
local scripts_dir = cache_dir .. "/script"
local gui_dir = cache_dir .. "/gui"
local message_file = cache_dir .. "/__message__"

local function ensure_dirs()
    vim.fn.mkdir(scripts_dir, "p")
    vim.fn.mkdir(gui_dir, "p")
end

local function read_file(path)
    local f = assert(io.open(path, "r"))
    local data = f:read("*a")
    f:close()
    return data
end

local function write_file(path, data)
    local f = assert(io.open(path, "w"))
    f:write(data or "")
    f:close()
end

-- Networking: talk to TTS's External Editor API on 127.0.0.1:39999,
-- receive its reply on a listener bound to 127.0.0.1:39998.

-- Fire-and-forget: send a JSON payload to TTS on port 39999.
local function send_to_tts(payload)
    local client = vim.uv.new_tcp()
    if client == nil then
        return
    end
    client:connect("127.0.0.1", 39999, function(err)
        if err then
            vim.schedule(function()
                vim.notify("tts_editor: connect failed: " .. err, vim.log.levels.ERROR)
            end)
            client:close()
            return
        end
        client:write(payload, function()
            client:shutdown(function()
                client:close()
            end)
        end)
    end)
end

-- Starts a listener on 39998 and invokes on_reply(raw_string) once TTS
-- has sent its data and closed the connection. Binding/listening happen
-- synchronously before this function returns, so it's safe to call
-- send_to_tts() for the triggering request immediately after.
local function listen_for_reply(on_reply)
    local server = vim.uv.new_tcp()
    if server == nil then
        return
    end
    server:bind("127.0.0.1", 39998)
    server:listen(128, function(listen_err)
        if listen_err then
            vim.schedule(function()
                vim.notify("tts_editor: listen failed: " .. listen_err, vim.log.levels.ERROR)
            end)
            server:close()
            return
        end

        local client = vim.uv.new_tcp()
        if client == nil then
            return
        end
        server:accept(client)

        local chunks = {}
        client:read_start(function(read_err, data)
            if read_err then
                vim.schedule(function()
                    vim.notify("tts_editor: read failed: " .. read_err, vim.log.levels.ERROR)
                end)
                client:close()
                server:close()
                return
            end

            if data then
                table.insert(chunks, data)
            else
                -- data == nil signals EOF: TTS closed its side after sending.
                client:close()
                server:close()
                local raw = table.concat(chunks)
                vim.schedule(function()
                    on_reply(raw)
                end)
            end
        end)
    end)
end

-- ---------------------------------------------------------------------
-- load / save
-- ---------------------------------------------------------------------

local function handle_reply(raw)
    write_file(message_file, raw)

    local ok, message = pcall(vim.json.decode, raw)
    if not ok then
        vim.notify("tts_editor: failed to parse TTS reply: " .. message, vim.log.levels.ERROR)
        return
    end

    if message.messageID ~= 1 or not message.scriptStates then
        vim.notify("tts_editor: unexpected messageID: " .. tostring(message.messageID), vim.log.levels.ERROR)
        return
    end

    local qf_entries = {}

    for _, state in ipairs(message.scriptStates) do
        local name = state.name or state.guid
        local script_path = scripts_dir .. "/" .. name .. ".lua"
        local gui_path = gui_dir .. "/" .. name .. ".xml"

        write_file(script_path, state.script)
        write_file(gui_path, state.gui or "")

        table.insert(qf_entries, { filename = script_path, text = name })
    end

    -- populate the quickfix list so you can
    -- :copen and jump straight to any object's script.
    vim.fn.setqflist(qf_entries, "r")
    vim.notify(("tts_editor: loaded %d script(s), see :copen"):format(#qf_entries))
end

function M.load()
    ensure_dirs()
    listen_for_reply(handle_reply)
    send_to_tts(vim.json.encode({ messageID = 0 }))
end

function M.save()
    ensure_dirs()

    local files = vim.fn.glob(scripts_dir .. "/*.lua", false, true)
    local script_states = {}

    for _, path in ipairs(files) do
        local name = vim.fn.fnamemodify(path, ":t:r")
        local guid = (name == "Global") and "-1" or name
        local script = read_file(path)

        table.insert(script_states, {
            name = name,
            guid = guid,
            script = script,
            ui = "",
        })
    end

    local message = { messageID = 1, scriptStates = script_states }
    local json = vim.json.encode(message)

    write_file(message_file, json)
    send_to_tts(json)

    vim.notify(("tts_editor: sent %d script(s) to TTS"):format(#script_states))
end

-- MARK: user commands

function M.setup()
    vim.keymap.set("n", "<leader>T", M.load, { desc = "Pull code from TTS socket" })
    vim.keymap.set("n", "<leader>t", M.save, { desc = "Push code to TTS socket" })
end
