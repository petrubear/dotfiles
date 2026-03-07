return {
	"linux-cultist/venv-selector.nvim",
	ft = "python",
	keys = { { ",v", "<cmd>VenvSelect<cr>" } },
	opts = {
		changed_venv_hooks = {
			function(venv_path)
				local python_path = venv_path .. "/bin/python"
				-- Persist for when pyright restarts
				vim.lsp.config("pyright", {
					settings = { python = { pythonPath = python_path } },
				})
				-- Stop clients — they auto-restart on the open buffer
				for _, client in ipairs(vim.lsp.get_clients({ name = "pyright" })) do
					vim.lsp.stop_client(client.id, true)
				end
			end,
		},
	},
}
