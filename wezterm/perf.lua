local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	config.scrollback_lines = 100000 -- default is 3500, way too low for logs
	config.enable_scroll_bar = true -- useful when reviewing long stack traces
	-- config.max_fps = 60
	config.animation_fps = 1 -- disable animations for snappier feel
	config.front_end = "WebGpu"
	config.webgpu_power_preference = "HighPerformance"
end

return module
