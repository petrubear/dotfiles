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
					background_colour = "#0C0E11", -- PetruTheme mantle
				})
				-- Do NOT set vim.notify here; Noice manages that
			end,
		},
	},
}
