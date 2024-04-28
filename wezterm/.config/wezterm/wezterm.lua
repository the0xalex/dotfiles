-- https://wezfurlong.org/wezterm/config/files.html
-- Don't know lua?  read this: https://learnxinyminutes.com/docs/lua/
local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font("Hack Nerd Font")
config.font_size = 15
config.harfbuzz_features = { "calt", "liga" }
config.front_end = "WebGpu"
config.enable_scroll_bar = false
config.scrollback_lines = 8192
config.automatically_reload_config = true
config.default_cursor_style = "BlinkingBar"
config.initial_cols = 120
config.initial_rows = 70
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true

-- config.color_scheme = "Tokyo Night"
-- config.color_scheme = "rose-pine"
config.color_scheme = "Dark+"
config.colors = {
	selection_bg = "#6BB2C1",
	selection_fg = "#292C34",
}
config.window_background_opacity = 0.80
config.macos_window_background_blur = 20

config.window_close_confirmation = "NeverPrompt"

return config
