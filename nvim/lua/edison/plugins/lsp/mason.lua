return {
	{
		"williamboman/mason-lspconfig.nvim",
		opts = {
			-- list of servers for mason to install
			ensure_installed = {
				"eslint",
				"gradle_ls",
				"jdtls",
				"lua_ls",
				"marksman",
				"pyright",
				"yamlls",
			},
		},
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"neovim/nvim-lspconfig",
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		opts = {
			ensure_installed = {
				"black", -- python formatter
				"eslint_d",
				"isort", -- python formatter
				"java-debug-adapter",
				"java-test",
				"prettier", -- prettier formatter
				"pylint",
				"shellcheck",
				"stylua", -- lua formatter
			},
		},
		dependencies = {
			"williamboman/mason.nvim",
		},
	},
}
