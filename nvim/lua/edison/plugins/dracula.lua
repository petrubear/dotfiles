-- This requires Dracula Pro.
-- read instructions on how to install it first.
return {
	dir = vim.fn.stdpath("data") .. "/site/pack/themes/start/dracula_pro",
	priority = 10000,
	name = "dracula_pro",
	lazy = false,
	config = function()
		vim.g.dracula_colorterm = 0
		vim.cmd("colorscheme dracula_pro")
	end,
}
