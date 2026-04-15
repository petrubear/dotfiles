-- PetruTerm LLM configuration (Phase 2)
-- Set enabled = true and provide your api_key to activate AI features.

local module = {}

function module.apply_to_config(config)
	config.llm = {
		enabled = true, -- Set to true to enable AI features

		provider = "openrouter",
		model = "openrouter/auto:free",
		api_key = os.getenv("OPENROUTER_API_KEY"),
		base_url = nil, -- nil = use provider default

		-- Local provider examples:
		-- provider = "lmstudio",
		-- base_url = "http://localhost:1234/v1",
		-- model = "qwen/qwen3.5-9b",
		-- provider = "ollama",   base_url = "http://localhost:11434",  model = "llama3"

		features = {
			nl_to_command = true, -- Natural language → shell command
			explain_output = true, -- Explain selected/last output
			fix_last_error = true, -- Fix suggestion on non-zero exit
			context_chat = true, -- Multi-turn chat with terminal context
		},

		context_lines = 50, -- Lines of terminal output sent as context
	}
end

return module
