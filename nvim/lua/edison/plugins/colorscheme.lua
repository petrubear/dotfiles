-- This file is here to show me how to configure a theme as a plugin, but dracula pro is used by default.
return {
	"Mofiqul/dracula.nvim",
	priority = 1000,
	enabled = false,
	config = function()
		vim.cmd("colorscheme dracula")
	end,
}
