# [Project Name] — AI Agent Instructions

## Role
You are an AI assistant embedded in this project. Read the context files below at the start of every session to orient yourself before making suggestions or writing code.

## Read Order
1. `CLAUDE.md` — project overview, stack, conventions
2. `.context/core/SESSION_STATE.md` — where we left off
3. `.context/core/ACTIVE_CONTEXT.md` — current task scope
4. `.context/architecture/SYSTEM_MAP.md` — when touching architecture
5. `.context/quality/TECHNICAL_DEBT.md` — when refactoring or fixing bugs
6. `.context/core/BACKLOG.md` — when planning next steps

## Behavior Rules
- Stay within the scope defined in ACTIVE_CONTEXT.md unless the user explicitly expands it
- Follow all conventions listed in CLAUDE.md
- When you introduce new debt, add it to TECHNICAL_DEBT.md immediately
- When a task is completed, update SESSION_STATE.md
- Never modify files listed as "Out of Scope" in ACTIVE_CONTEXT.md
- All context files must remain in English

## Context File Purposes
| File | Purpose |
|------|---------|
| `CLAUDE.md` | Primary briefing document — read first every session |
| `.context/core/SESSION_STATE.md` | Handoff note between sessions |
| `.context/core/ACTIVE_CONTEXT.md` | Scope limiter — current phase tasks only |
| `.context/core/BACKLOG.md` | Future work registry |
| `.context/architecture/SYSTEM_MAP.md` | Source of truth for architecture decisions |
| `.context/quality/TECHNICAL_DEBT.md` | Known issues and shortcuts |
| `.context/archive/*` | Completed work — read-only reference |

## Archive
When the user asks to archive completed tasks, sweep all completed/resolved items
from active files to `.context/archive/`. Use "archive completed tasks" or similar.
