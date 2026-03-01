# OpenCode

Terminal-based AI coding assistant configured for local LLM usage via LM Studio and remote access via OpenRouter.

## Dependencies

- `opencode` -- install via `brew install opencode`
- [LM Studio](https://lmstudio.ai/) -- local LLM server running at `http://127.0.0.1:1234`
- An OpenRouter API key (set via `OPENROUTER_API_KEY` env variable) for remote model access

## Configuration

### Providers

| Provider | Type | Base URL | Model |
|----------|------|----------|-------|
| LM Studio | Local (`@ai-sdk/openai-compatible`) | `http://127.0.0.1:1234/v1` | `openai/gpt-oss-20b` |
| OpenRouter | Remote | Default | Via `OPENROUTER_API_KEY` env |

### MCP Integration

| Server | Type | URL | Status |
|--------|------|-----|--------|
| Context7 | Remote | `https://mcp.context7.com/mcp` | Disabled by default |

The Context7 API key is read from `~/.config/secrets/context7`.

### Theme

Custom Dracula theme (`themes/dracula.json`) with the full Dracula color palette:

| Element | Color |
|---------|-------|
| Primary | `#BD93F9` (purple) |
| Secondary | `#8BE9FD` (cyan) |
| Accent | `#FF79C6` (pink) |
| Error | `#FF5555` (red) |
| Warning | `#FFB86C` (orange) |
| Success | `#50FA7B` (green) |
| Background | `#282A36` |
| Foreground | `#F8F8F2` |

The theme also includes custom colors for diff views, markdown rendering, and syntax highlighting.
