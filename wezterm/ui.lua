local wezterm = require("wezterm")
local colors = require("colors")
local module = {}

function module.apply_to_config(config)
	config.colors = colors["Dracula Pro"]
	config.enable_tab_bar = false
	config.font = wezterm.font("Monolisa Nerd Font")
	-- config.font_rules = { { intensity = "Normal", font = wezterm.font("Monolisa Nerd Font", { weight = "Medium" }) } }
	config.font_size = 16
	config.harfbuzz_features = { "calt=1", "liga=1", "dlig=1" }
	config.hide_tab_bar_if_only_one_tab = true
	config.use_fancy_tab_bar = true
	config.window_padding = { left = 20, right = 20, top = 30, bottom = 10 }
	config.window_decorations = "RESIZE"
	config.initial_window_state = "Maximized"
	config.window_close_confirmation = "NeverPrompt"
	config.quit_when_all_windows_are_closed = true
	config.native_macos_fullscreen_mode = false
end

return module
