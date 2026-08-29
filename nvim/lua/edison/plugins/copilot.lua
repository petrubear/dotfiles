return {}
--[[
return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			local source = require("copilot_cmp.source")

			source.is_available = function(self)
				if self.client:is_stopped() or self.client.name ~= "copilot" then
					return false
				end

				local get_source_client = function()
					if vim.lsp.get_clients == nil then
						return vim.lsp.get_active_clients({
							bufnr = vim.api.nvim_get_current_buf(),
							id = self.client.id,
						})
					end

					return vim.lsp.get_clients({
						bufnr = vim.api.nvim_get_current_buf(),
						id = self.client.id,
					})
				end

				return next(get_source_client()) ~= nil
			end

			require("copilot_cmp").setup()
		end,
	},
}
]]
