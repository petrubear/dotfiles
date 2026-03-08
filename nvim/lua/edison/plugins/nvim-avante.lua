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
		-- provider = "openrouter",
		provider = "lmstudio",
		providers = {
			openrouter = {
				__inherited_from = "openai",
				endpoint = "https://openrouter.ai/api/v1",
				api_key_name = "OPENROUTER_API_KEY",
				-- model = "qwen/qwen3.5-35b-a3b",
				model = "qwen/qwen3-coder-next",
			},
			lmstudio = {
				__inherited_from = "openai",
				api_key_name = "",
				endpoint = "http://127.0.0.1:1234/v1",
				model = "qwen/qwen3.5-35b-a3b",
			},
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
}
