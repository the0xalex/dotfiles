-- Alex's base config
local builtins = {
  "options",
  "keymaps",
}

---Safely loads modules. Prints a warning if one failed to load.
for _, module in ipairs(builtins) do
  local mod_name = "alex" .. "." .. module
  local loaded = pcall(require, mod_name)
  if not loaded then
    vim.print("No module `" .. module .. "`")
  end
end
