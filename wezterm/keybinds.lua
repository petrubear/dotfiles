local wezterm = require("wezterm")
local module = {}

function module.apply_to_config(config)
	config.leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 }
	config.keys = {
		-- fix Shift+Enter
		{ key = "Return", mods = "SHIFT", action = wezterm.action.SendString("\x1b\r") },
		-- Pane splitting (tmux-style)
		{
			key = "%",
			mods = "LEADER",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = '"',
			mods = "LEADER",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},

		-- Pane navigation (Vim-style: h, j, k, l)
		{
			key = "h",
			mods = "LEADER",
			action = wezterm.action.ActivatePaneDirection("Left"),
		},
		{
			key = "l",
			mods = "LEADER",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},
		{
			key = "k",
			mods = "LEADER",
			action = wezterm.action.ActivatePaneDirection("Up"),
		},
		{
			key = "j",
			mods = "LEADER",
			action = wezterm.action.ActivatePaneDirection("Down"),
		},

		-- Close pane
		{
			key = "x",
			mods = "LEADER",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},
	}
end
return module
