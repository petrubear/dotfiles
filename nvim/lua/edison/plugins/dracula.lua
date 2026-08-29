-- This requires Dracula Pro.
-- read instructions on how to install it first.
--
-- Superseded by petrutheme.lua as the active colorscheme. Kept installed but
-- disabled -- flip `enabled` back to true (and disable petrutheme.lua) to
-- switch back.
return {
	dir = vim.fn.stdpath("data") .. "/site/pack/themes/start/dracula_pro",
	priority = 10000,
	name = "dracula_pro",
	enabled = false,
	lazy = false,
	config = function()
		vim.g.dracula_colorterm = 0
		-- Dracula Pro italicizes many groups (types, parameters, attributes,
		-- language-specific groups, etc.) by default. Disable italics
		-- globally, then re-enable them only for Comment/Keyword below.
		vim.g.dracula_italic = 0
		vim.cmd("colorscheme dracula_pro")
		-- LSP semantic tokens override Treesitter (priority 125 vs 100).
		-- Dracula Pro doesn't define @lsp.type.modifier, so it inherits cyan.
		-- Override it to pink to match the Treesitter @keyword.modifier intent.
		vim.api.nvim_set_hl(0, "@lsp.type.modifier", { link = "DraculaPink" })
		-- Dracula Pro doesn't define @lsp.mod.deprecated, so deprecated symbols
		-- (methods, classes) have no visual indication. Add strikethrough.
		vim.api.nvim_set_hl(0, "@lsp.mod.deprecated", { strikethrough = true })
		-- Keyword and Comment are the only groups that should stay italic;
		-- reapply italic on top of their plain (now non-italic) colors.
		local pink = vim.api.nvim_get_hl(0, { name = "DraculaPink" })
		local comment = vim.api.nvim_get_hl(0, { name = "DraculaComment" })
		vim.api.nvim_set_hl(0, "Keyword", vim.tbl_extend("force", pink, { italic = true }))
		vim.api.nvim_set_hl(0, "@keyword", vim.tbl_extend("force", pink, { italic = true }))
		vim.api.nvim_set_hl(0, "Comment", vim.tbl_extend("force", comment, { italic = true }))
		vim.api.nvim_set_hl(0, "@comment", vim.tbl_extend("force", comment, { italic = true }))
	end,
}
