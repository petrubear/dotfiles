return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewFileHistory",
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<leader>vd",
			"<cmd>DiffviewOpen<CR>",
			desc = "Open Git diff view",
		},
		{
			"<leader>vh",
			"<cmd>DiffviewFileHistory %<CR>",
			desc = "Open file Git history",
		},
		{
			"<leader>vx",
			"<cmd>DiffviewClose<CR>",
			desc = "Close Git diff view",
		},
	},
}
