---
name: project-context
description: >
  Initializes and manages a structured AI context system for software projects.
  Use this skill whenever a user wants to:
  - Start a new project and set up AI context files
  - Initialize a `.context/` folder structure for an existing project
  - Plan a new application with AI assistance (tech stack, architecture, tasks, phases)
  - Archive completed tasks, resolved debt, or finished backlog items
  - Understand what to build next based on their project plan

  Trigger on phrases like: "initialize project", "set up context", "start a new project",
  "plan my app", "archive completed tasks", "archive resolved debt", "set up my project files",
  "create context files", or any variant in any language.

  All generated files must always be written in English regardless of the language the user speaks.
---

# Project Context Skill

This skill does two things:

1. **Initialize** — Interview the user, fully understand what they're building, and generate a complete populated `.context/` folder.
2. **Archive** — Sweep all completed/resolved items from active context files into dated archive files.

---

## Folder Structure Created

```
.context/
├── core/
│   ├── SESSION_STATE.md
│   ├── ACTIVE_CONTEXT.md
│   └── BACKLOG.md
├── architecture/
│   └── SYSTEM_MAP.md
├── quality/
│   └── TECHNICAL_DEBT.md
└── archive/
    ├── ACTIVE_CONTEXT_ARCHIVE.md
    ├── BACKLOG_ARCHIVE.md
    └── TECHNICAL_DEBT_ARCHIVE.md
CLAUDE.md                    ← project root
AGENTS.md                    ← project root
```

---

## Workflow: Which path are we on?

Read the user's message and decide:

- If they want to **archive** → go to [Archive Workflow](#archive-workflow)
- If they want to **initialize / plan / set up** → go to [Initialize Workflow](#initialize-workflow)
- If unclear → ask: "Do you want to set up context files for a new project, or archive completed tasks from an existing one?"

---

## Initialize Workflow

### Phase 1 — Interview

Your goal is to fully understand what the user is building to the level of detail needed to populate every section of every template. **Do not assume anything. If you are not sure, ask.**

Read `references/interview-guide.md` for the full interview structure, question flow, and decision rules for when to ask follow-ups.

Key rules:
- Mix open-ended and specific questions based on complexity of the topic
- Ask grouped questions when topics are related and simple
- Ask one at a time when the topic is nuanced or the user's answer reveals complexity
- If the user shares files (designs, specs, existing code), treat them as reference material only — do not write them as output
- Keep asking until you are confident you can fill every field of every template with no placeholders

### Phase 2 — Generate Context Files

Once the interview is complete, generate all files below using the templates in `assets/context-templates/`. All files must be fully populated — no placeholder brackets remaining.

Files to generate (in this order):
1. `CLAUDE.md` — project root
2. `AGENTS.md` — project root
3. `.context/core/SESSION_STATE.md`
4. `.context/core/ACTIVE_CONTEXT.md` — set to Phase 1 tasks
5. `.context/core/BACKLOG.md` — all phases beyond Phase 1
6. `.context/architecture/SYSTEM_MAP.md`
7. `.context/quality/TECHNICAL_DEBT.md` — start empty but with structure ready
8. `.context/archive/ACTIVE_CONTEXT_ARCHIVE.md` — empty archive, structure only
9. `.context/archive/BACKLOG_ARCHIVE.md` — empty archive, structure only
10. `.context/archive/TECHNICAL_DEBT_ARCHIVE.md` — empty archive, structure only

### Phase 3 — Present the Build Plan

After writing all files, present the recommended build order to the user in the conversation (do not write this to a file). Format:

```
## Recommended Build Order

### Phase 1: [Name] — [goal in one sentence]
Priority: P0
1. [Task]
2. [Task]
...

### Phase 2: [Name] — [goal in one sentence]
Priority: P1
1. [Task]
...
```

Then tell the user: "ACTIVE_CONTEXT.md is set to Phase 1. When you complete a phase, ask me to archive completed tasks and I'll sweep them out and update the active context."

---

## Archive Workflow

Detect archive intent from user message. Trigger words include (any language): "archive", "clean up completed", "move done tasks", "sweep completed", "archivar", "archiver", etc.

Read `references/archive-guide.md` for the full archive logic, item detection rules, and file update procedures.

**Never modify items that are not completed/resolved. Only sweep what is done.**

---

## Critical Rules

- All output files must be written in **English**, regardless of the user's language
- Do **not** write any files other than the `.context/` structure and root `CLAUDE.md` / `AGENTS.md`
- Do **not** leave any `[bracketed placeholders]` in generated files
- Do **not** generate `SYSTEM_MAP.md` with vague architecture — ask until you have enough detail
- The archive files must always append, never overwrite previous archive runs
