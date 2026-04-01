return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		-- The new 'main' branch doesn't use require("nvim-treesitter.configs").setup()
		-- Highlighting is enabled by default in the new version.

		-- If you need to manually add languages to 'ensure_installed',
		-- you now use the global variable or the new API:
		require("nvim-treesitter").setup({
			-- NOTE: If 'require("nvim-treesitter").setup' also fails,
			-- it means the rewrite is even further along.
			-- Try just the registration below first.
			highlight = { enable = true },
			indent = { enable = true },
			ensure_installed = {
				"bash",
				"css",
				"dockerfile",
				"gitignore",
				"graphql",
				"html",
				"java",
				"javascript",
				"json",
				"kotlin",
				"lua",
				"markdown",
				"markdown_inline",
				"prisma",
				"python",
				"query",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			},
		})

		-- Use the modern Neovim API for zsh
		vim.treesitter.language.register("bash", "zsh")
	end,
}
