-- PetruTerm LLM configuration (Phase 2)
-- Set enabled = true and provide your api_key to activate AI features.

local module = {}

function module.apply_to_config(config)
	config.llm = {
		enabled = true, -- Set to true to enable AI features

		-- Backend: "provider" (direct LLM API, default) or "agent" (ACP agent
		-- process, e.g. Claude Code). When "agent", provider/model below are
		-- ignored and `agent` is used instead.
		backend = "agent",

		-- ACP agent config (used only when backend = "agent").
		-- Requires Node.js/npx installed — the adapter below is an npm package
		-- that bridges the Claude Agent SDK to the ACP protocol over stdio.
		-- Test it standalone first: `npx -y @agentclientprotocol/claude-agent-acp`
		-- should hang waiting on stdin (Ctrl+C to kill) — if that fails, the
		-- problem is Node/network, not PetruTerm.
		agent = {
			command = "npx",
			args = { "-y", "@agentclientprotocol/claude-agent-acp" },
			--   -- Auth: if `claude` (Claude Code CLI) is already logged in via OAuth
			--   -- on this machine, the SDK reuses those credentials and env can stay
			--   -- empty. Otherwise set your key here:
			env = {}, -- e.g. { ANTHROPIC_API_KEY = "sk-ant-..." }
			display_name = "Claude", -- label shown in the chat panel header (◈ Claude)
		},
		-- Fallback package name if the one above fails to resolve via npx:
		-- "@zed-industries/claude-code-acp" (older name, still the hardcoded
		-- default in the agent-client-protocol-tokio crate we vendor).

		-- provider = "openrouter",
		-- model = "openrouter/auto:free",
		-- api_key = os.getenv("OPENROUTER_API_KEY"),
		-- base_url = nil, -- nil = use provider default

		-- GitHub Copilot (requires active Copilot subscription):
		-- provider = "copilot",
		-- model = "gpt-4o-mini", -- also: gpt-4o, claude-3.5-sonnet, claude-3.7-sonnet, o3-mini
		-- api_key is auto-resolved: GITHUB_TOKEN env var → `gh auth token` → Keychain.
		-- Easiest setup: gh auth login, then export GITHUB_TOKEN=$(gh auth token) in ~/.zshrc

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

		ui = {
			width_cols = 55,
			background = "#1a1726",
			user_fg = "#bfe5ff",
			assistant_fg = "#8dff85",
			input_fg = "#ffffff",
		},
	}
end

return module
