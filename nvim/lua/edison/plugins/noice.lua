return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		notify = { enabled = false }, -- nvim-notify handles this (loaded by venv-selector)
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			config = function()
				require("notify").setup({
					background_colour = "DraculaBgDark", -- Dracula Pro background
				})
				-- Do NOT set vim.notify here; Noice manages that
			end,
		},
	},
}
