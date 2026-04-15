-- PetruTerm UI configuration
-- Controls font, colors, window appearance.

local petruterm = require("petruterm")
local module = {}

function module.apply_to_config(config)
	-- Font
	-- config.font = petruterm.font("JetBrainsMono Nerd Font Mono") -- Override with "Monolisa Nerd Font" if installed
	config.font = petruterm.font("Monolisa Nerd Font")
	config.font_size = 16
	config.font_line_height = 1.4

	-- LCD subpixel antialiasing (FreeType LCD mode, 3× horizontal resolution)
	-- Significantly sharper text on LCD displays; JetBrainsMono Nerd Font recommended for best results
	config.lcd_antialiasing = true

	-- HarfBuzz OpenType features: contextual alternates, ligatures, discretionary ligatures
	config.font_features = { "calt=1", "liga=1", "dlig=1" }

	-- Color scheme (Dracula Pro)
	config.colors = {
		foreground = "#f8f8f2",
		background = "#22212c",
		cursor_bg = "#9580ff",
		cursor_border = "#9580ff",
		cursor_fg = "#f8f8f2",
		selection_bg = "#454158",
		selection_fg = "#c6c6c2",
		ansi = { "#22212c", "#ff9580", "#8aff80", "#ffff80", "#9580ff", "#ff80bf", "#80ffea", "#f8f8f2" },
		brights = { "#504c67", "#ffaa99", "#a2ff99", "#ffff99", "#aa99ff", "#ff99cc", "#99ffee", "#ffffff" },
	}

	-- Window
	-- title_bar_style = "custom": transparent title bar, traffic lights in native position,
	--   content extends behind bar, window draggable from content area (macOS only).
	-- title_bar_style = "native": standard OS title bar.
	-- title_bar_style = "none": no chrome at all (fully borderless).
	-- top padding should be >= 60 when using "custom" to leave room for traffic lights.
	config.window = {
		borderless = false,
		start_maximized = true,
		title_bar_style = "custom",
		padding = { left = 20, right = 20, top = 60, bottom = 10 },
		opacity = 1.0,
	}

	config.enable_tab_bar = true
	config.hide_tab_bar_if_one = true

	-- ── Status bar ───────────────────────────────────────────────────────────
	-- style: "plain"     — text separators ( › and │ ).
	--        "powerline" — Nerd Font arrows ( and ). Requires a Nerd Font.
	config.status_bar = {
		enabled = true,
		position = "bottom",
		style = "powerline",
	}
end

return module
