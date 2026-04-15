return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")

		-- In the 'main' rewrite, highlighting is handled by Neovim core.
		-- We just need to ensure the parsers are installed.
		ts.install({
			"bash",
			"java",
			"lua",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"yaml",
			-- add others as needed
		})

		-- This replaces the old 'highlight = { enable = true }'
		-- It tells Neovim to use treesitter for all supported files
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
				if lang then
					pcall(vim.treesitter.start)
				end
			end,
		})

		-- Register zsh to use the bash parser
		vim.treesitter.language.register("bash", "zsh")
	end,
}
