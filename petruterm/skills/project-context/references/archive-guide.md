# Archive Guide

This guide defines how to detect completed/resolved items and move them to archive files.

---

## Trigger Detection

Archive is triggered when the user says something that means "move completed work out of the active files."
Examples (any language): "archive completed tasks", "clean up done items", "sweep resolved debt",
"archivar tareas completadas", "archiver les tâches terminées", etc.

---

## Archive Run Header

Every archive operation appends a dated section to each affected archive file:

```markdown
---

## Archive Run — YYYY-MM-DD

[items go here]
```

If no items are found in a file, do not append anything to that file.

---

## File-by-File Rules

### ACTIVE_CONTEXT.md → ACTIVE_CONTEXT_ARCHIVE.md

**What to archive:** Any requirement or acceptance criterion checkbox that is checked `[x]`.

**What to keep:** All unchecked items `[ ]`, all metadata (Current Focus, Started, Target Completion, Priority), all scope sections, Technical Approach, Patterns, Open Questions.

**Special case:** If ALL acceptance criteria are checked, archive the entire context block and reset ACTIVE_CONTEXT.md to the next phase from BACKLOG.md (promote the next P0 backlog item to active context).

**Archive format:**
```markdown
## Archive Run — YYYY-MM-DD

### [Feature/task name] (from Active Context)
Completed items:
- [x] [criterion]
- [x] [criterion]
```

---

### BACKLOG.md → BACKLOG_ARCHIVE.md

**What to archive:** Any backlog item where the status is marked complete. A backlog item is complete when:
- All its sub-tasks/requirements are checked `[x]`, OR
- The item has an explicit `**Status:** Done` / `**Status:** Complete` field

**What to keep:** All items without a completed status, regardless of priority.

**Archive format:**
```markdown
## Archive Run — YYYY-MM-DD

### [BACK-XXX] [Title]
- **Type:** [type]
- **Phase:** [phase]
- **Resolved:** YYYY-MM-DD
- **Notes:** [any relevant resolution notes]
```

---

### TECHNICAL_DEBT.md → TECHNICAL_DEBT_ARCHIVE.md

**What to archive:** Items in the "Resolved Debt" table AND any debt item explicitly marked as resolved in the priority sections.

**What to keep:** All unresolved P0–P3 items. Do not touch the Priority Definitions table.

**Archive format:**
```markdown
## Archive Run — YYYY-MM-DD

| ID | Title | Original Priority | Resolved | Resolution |
|----|-------|-------------------|----------|------------|
| [ID] | [Title] | [P0/P1/P2/P3] | [Date] | [How resolved] |
```

After archiving, clear the "Resolved Debt (Last 30 Days)" table in TECHNICAL_DEBT.md (reset it to empty with headers only) and update the **Total Items** and **Critical (P0)** counts at the top.

---

## After Archiving

1. Update `SESSION_STATE.md`:
   - Set **Last Updated** to today
   - Add to **Completed This Session**: "Archived completed tasks ([N] items across [files])"
   - Update **Next Session Priorities** if active context changed

2. Report to the user in the conversation (do not write this to a file):
   - How many items were archived from each file
   - Whether active context was promoted to a new phase
   - What the next priorities are

---

## Safety Rules

- **Never delete** — only move. The source file must retain all non-completed items intact.
- **Never modify** item content — copy as-is to the archive.
- **Never archive** items that are partially complete (some `[x]` and some `[ ]` in the same item block) — leave them in place.
- If the archive file does not exist yet, create it with the standard header before appending.
