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
		-- LSP semantic tokens override Treesitter (priority 125 vs 100).
		-- Dracula Pro doesn't define @lsp.type.modifier, so it inherits cyan.
		-- Override it to pink to match the Treesitter @keyword.modifier intent.
		vim.api.nvim_set_hl(0, "@lsp.type.modifier", { link = "DraculaPink" })
		-- Dracula Pro doesn't define @lsp.mod.deprecated, so deprecated symbols
		-- (methods, classes) have no visual indication. Add strikethrough.
		vim.api.nvim_set_hl(0, "@lsp.mod.deprecated", { strikethrough = true })
	end,
}
