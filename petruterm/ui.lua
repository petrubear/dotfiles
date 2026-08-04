-- PetruTerm UI configuration
-- Controls font, colors, window appearance.

local petruterm = require("petruterm")
local module = {}

function module.apply_to_config(config)
	-- Font
	-- config.font = petruterm.font("JetBrainsMono Nerd Font Mono") -- Override with "MonolisaCode Nerd Font" if installed
	config.font = petruterm.font("MonolisaCode Nerd Font")
	config.font_size = 16
	config.font_line_height = 1.4

	-- LCD subpixel antialiasing (FreeType LCD mode, 3× horizontal resolution)
	-- Significantly sharper text on LCD displays; JetBrainsMono Nerd Font recommended for best results
	config.lcd_antialiasing = true

	-- HarfBuzz OpenType features: contextual alternates, ligatures, discretionary ligatures
	config.font_features = { "calt=1", "liga=1", "dlig=1" }
	config.font_fallbacks = { "Apple Color Emoji", "Noto Color Emoji" }

	-- Color scheme (Dracula Pro)
	config.colors = {
		foreground = "#e0e0e8",
		background = "#0e0e10",
		cursor_bg = "#9580ff",
		cursor_border = "#9580ff",
		cursor_fg = "#e0e0e8",
		selection_bg = "#2a2a3a",
		selection_fg = "#e0e0e8",
		ansi = { "#0e0e10", "#ff9580", "#8aff80", "#ffff80", "#9580ff", "#ff80bf", "#80ffea", "#e0e0e8" },
		brights = { "#2a2a2f", "#ffaa99", "#a2ff99", "#ffff99", "#aa99ff", "#ff99cc", "#99ffee", "#ffffff" },

		-- Semantic UI tokens (optional — derived from base colors when omitted).
		-- ui_accent:         focus borders, highlights.       Default: cursor_bg.
		-- ui_surface:        panel / sidebar / palette bg.    Default: background +15% brightness.
		-- ui_surface_active: selected item bg.                Default: selection_bg.
		-- ui_surface_hover:  hovered item bg.                 Default: background +8% brightness.
		-- ui_muted:          separators, secondary text.      Default: foreground at 35% alpha.
		-- ui_success:        positive indicators.             Default: ansi[3] (green).
		-- ui_overlay:        toast / modal semi-transparent.  Default: background at 95% alpha.
		--   Supports 6-char (#rrggbb) or 8-char (#rrggbbaa) hex values.
		ui_accent = "#9580ff",
		ui_surface = "#1a1a1e",
		ui_surface_active = "#2a2a3a",
		ui_surface_hover = "#181820",
		ui_muted = "#e0e0e859",
		ui_success = "#8aff80",
		ui_overlay = "#1a1a1eff",
	}

	-- Window
	-- title_bar_style = "custom": transparent title bar, traffic lights in native position,
	--   content extends behind bar, window draggable from content area (macOS only).
	-- title_bar_style = "native": standard OS title bar.
	-- title_bar_style = "none": no chrome at all (fully borderless).
	-- "custom" titlebar handles traffic lights clearance via TITLEBAR_HEIGHT internally.
	-- top padding is the gap between the titlebar and the first terminal row.
	config.window = {
		borderless = false,
		start_maximized = true,
		title_bar_style = "custom",
		padding = { left = 10, right = 10, top = 5, bottom = 5 },
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

	config.input_ghost_text = false
	config.input_syntax_highlight = false
end

return module
