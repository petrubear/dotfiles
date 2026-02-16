return {
	"HiPhish/rainbow-delimiters.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "dracula_pro" },
	config = function()
		local rainbow_delimiters = require("rainbow-delimiters")

		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = rainbow_delimiters.strategy["global"],
				vim = rainbow_delimiters.strategy["local"],
			},
			query = {
				[""] = "rainbow-delimiters",
				lua = "rainbow-blocks",
			},
			priority = {
				[""] = 110,
				lua = 210,
			},
			highlight = {
				"DraculaPink",
				"DraculaPurple",
				"DraculaBlue",
				"DraculaOrange",
				"DraculaGreen",
				"DraculaViolet",
				"DraculaCyan",
			},
		}
	end,
}
