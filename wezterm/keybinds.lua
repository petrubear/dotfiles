local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	config.keys = {
		-- fix Shift+Enter
		{ key = "Return", mods = "SHIFT", action = wezterm.action.SendString("\x1b\r") },
	}
end
return module
