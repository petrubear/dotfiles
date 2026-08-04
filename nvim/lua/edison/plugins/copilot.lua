return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			local orig_notify = vim.notify
			vim.notify = function(msg, ...)
				if type(msg) == "string" and msg:find("client%.is_stopped is deprecated") then
					return
				end
				orig_notify(msg, ...)
			end
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
			require("copilot_cmp").setup()
		end,
	},
}
