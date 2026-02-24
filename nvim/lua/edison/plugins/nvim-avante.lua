return {
	"yetone/avante.nvim",
	build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
		or "make",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	---@type avante.Config
	opts = {
		instructions_file = "AGENTS.md",
		provider = "openrouter",
		providers = {
			openrouter = {
				__inherited_from = "openai",
				endpoint = "https://openrouter.ai/api/v1",
				api_key_name = "OPENROUTER_API_KEY",
				model = "qwen/qwen3-coder",
			},
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
}
