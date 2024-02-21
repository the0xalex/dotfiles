local M = {}

-- Work in progress. Thinking of creating an environment HUD element in lualine.
-- each of my architectures for doing so ends up leaking the state on buffer reset.
-- This is a func to clean it up.
function M.env_cleanup(venv)
    if string.find(venv, "/") then
        local final_venv = venv
        for w in venv:gmatch "([^/]+)" do
            final_venv = w
        end
        venv = final_venv
    end
    return venv
end

return M
