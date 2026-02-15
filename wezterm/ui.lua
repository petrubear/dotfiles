local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	config.color_scheme = "Dracula"
	config.font = wezterm.font("Monolisa Nerd Font")
	config.font_size = 16
	config.use_fancy_tab_bar = true
	config.hide_tab_bar_if_only_one_tab = true
	config.enable_tab_bar = false
	config.window_decorations = "RESIZE"
end

return module
