# Kiro CLI

Kiro CLI agent and tool configuration. Includes 8 custom agents, shared per-domain contexts, skills, and steering files for coding standards and agent behavior.

## Dependencies

- [Kiro CLI](https://kiro.dev/) -- the CLI tool itself
- Node.js / `npx` -- required by several MCP servers (Context7, Atlassian, Chrome DevTools, Sequential Thinking)
- Java 21 (via SDKMAN) -- required by the Oracle agent MCP server
- Oracle JDBC driver (`ojdbc17-23.9.0.25.07.jar`) -- for Oracle DB connectivity

## CLI Settings

Configured in `settings/cli.json`:

- **Default model**: `claude-sonnet-4.6`
- **Default agent**: `petru_agent`
- **Autocomplete theme**: Dracula
- **Autocomplete**: Disabled
- **Inline**: Disabled
- **Subagent**: Enabled
- **Checkpoint**: Enabled
- **Tangent mode**: Enabled
- **Thinking**: Disabled
- **Todo list**: Enabled
- **Code intelligence**: Enabled
- **Knowledge**: Enabled
- **Telemetry**: Disabled
- **CodeWhisperer content sharing**: Disabled

### Knowledge Exclude Patterns

Directories and files excluded from indexing: `**/target/**`, `**/build/**`, `**/.git/**`, `**/.idea/**`, `**/.metadata/**`, `**/.vscode/**`, `**/.classpath/**`, `**/.project/**`, `**/node_modules/**`, `**/*.class`, `**/*.jar`, `**/*.iml`, `**/*.flattened-pom.xml`, `**/.DS_Store`

## Agents

All 8 agents use `claude-sonnet-4.6` as their model.

| Agent | Description | MCP Servers |
|-------|-------------|-------------|
| `petru_agent` | Default general-purpose agent for development, writing, analysis, planning, and research | None |
| `context7_agent` | Context7 MCP integration for library documentation lookup | `context7` (via `@upstash/context7-mcp`) |
| `jasper_agent` | JasperReports expert for creating, editing, and migrating `.jrxml` reports | None |
| `jira_agent` | Jira integration for reading issues and attached logs | `atlassian` (via `mcp-remote`) |
| `logs_agent` | Java log analyzer for Log4j, Logback, SLF4J, stack traces, and performance issues | `sequential-thinking` (via `@modelcontextprotocol/server-sequential-thinking`) |
| `oracle_agent` | Oracle DB, PL/SQL, and Forms expert (default schema: EEFISA_PREPROD) | `oracle` (custom Quarkus MCP server with JDBC) |
| `test_agent` | Java unit test creator using JUnit and Mockito | None |
| `webdev_agent` | Web developer with Chrome DevTools access for debugging across modern and legacy stacks | `chrome-dev-tools` (via `chrome-devtools-mcp`) |

### Agent Tools

Each agent has a curated set of allowed tools. Common tools across agents include: `read`, `introspect`, `knowledge`, `thinking`, `delegate`, `grep`, `glob`, `use_subagent`.

The `webdev_agent` has the most specialized tool set with 18 Chrome DevTools actions (click, evaluate_script, fill, get_computed_css, get_network_requests, navigate, screenshot, snapshot, etc.).

## Shared Contexts

Per-domain `AGENTS.md` files loaded as resources by the corresponding agents:

| Directory | Used By | Purpose |
|-----------|---------|---------|
| `shared/default/` | `petru_agent` | Default context |
| `shared/context7/` | `context7_agent` | Context7 MCP integration context |
| `shared/jira/` | `jira_agent` | Jira integration context |
| `shared/log/` | `logs_agent` | Log analysis context |
| `shared/oracle/` | `oracle_agent` | Oracle DB context (also includes MCP JAR files) |
| `shared/test/` | `test_agent` | Testing context |
| `shared/webdev/` | `webdev_agent` | Web development context |

## Skills

| Skill | Path | Description |
|-------|------|-------------|
| `jasper-helper` | `skills/jasper-helper/SKILL.md` | JasperReports 7 migration guide for DynamicJasper/JacksonReportLoader format. Documents the non-standard XML format required when using DynamicJasper with JasperReports 7 (differs from official XSD documentation). |

## Steering

Global behavior and coding standards injected into all agents via `file://~/.kiro/steering/**/*.md`:

| File | Purpose |
|------|---------|
| `steering/coding-standards.md` | Language-specific coding standards for Java, Kotlin, TypeScript, JSON, YAML, Shell, HTML, and Markdown. Uses 4-space indentation for Java/Kotlin/TS projects. |
| `steering/soul.md` | Agent personality and behavior guidelines |

## Installation

Symlink to the Kiro CLI config directory:

```sh
ln -s ~/dotfiles/kiro-cli/agents ~/.kiro/agents
ln -s ~/dotfiles/kiro-cli/settings ~/.kiro/settings
ln -s ~/dotfiles/kiro-cli/shared ~/.kiro/shared
ln -s ~/dotfiles/kiro-cli/skills ~/.kiro/skills
ln -s ~/dotfiles/kiro-cli/steering ~/.kiro/steering
```
