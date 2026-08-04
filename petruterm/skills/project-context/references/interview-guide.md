# Interview Guide

This guide defines how to conduct the project initialization interview.
Work through the topics below. Not all questions are required for every project —
use judgment. If the user's answer makes a question irrelevant, skip it.
If an answer raises new questions, ask them before moving on.

---

## Opening

Start with one open-ended question to get the user talking:

> "Tell me about the project — what are you building and what problem does it solve?"

Let them answer freely. Extract as much as you can from their response before asking follow-ups.

---

## Topic Areas

Work through all relevant topic areas. Group related simple questions together.
Ask individually when the topic is complex or the answer reveals nuance.

---

### 1. Purpose & Users

Goal: understand the "why" and "who" well enough to write the CLAUDE.md overview.

- What problem does this solve?
- Who are the primary users? (internal team, consumers, businesses, developers)
- What does success look like for users?
- Are there secondary users or admin roles?

Ask if unclear: "Is this a tool for you personally, your team, or external users?"

---

### 2. App Type & Platform

Goal: determine the deployment target and core architecture pattern.

- Is this a web app, mobile app, desktop app, API/backend, CLI, or a combination?
- If web: is it a SPA, SSR, static site, or something else?
- If mobile: iOS, Android, or cross-platform?
- If API: REST, GraphQL, gRPC, or mixed?
- Does it need to run offline or on edge?

---

### 3. Tech Stack

Goal: fill the Tech Stack section of CLAUDE.md and inform SYSTEM_MAP.md choices.

Ask about each relevant layer:

- **Language:** Do they have a preference or constraint? (e.g., must use TypeScript, team knows Python)
- **Framework:** Do they have one in mind? If not, suggest 1-2 appropriate options and ask.
- **Database:** Relational, document, key-value, or none? Specific preference?
- **Auth:** Third-party (Auth0, Clerk, Supabase Auth) or custom? OAuth providers needed?
- **Infrastructure:** Cloud provider preference? Serverless or containerized? CI/CD tooling?
- **Key dependencies:** Any libraries they know they want (payment SDKs, email, AI, etc.)?

If the user is non-technical or unsure, ask what outcome they need and recommend a stack. Confirm before proceeding.

---

### 4. Architecture & Data Model

Goal: generate a meaningful SYSTEM_MAP.md. This is the area that most requires follow-up questions.

- What are the main entities in the system? (e.g., Users, Orders, Products)
- What are the relationships between them?
- Are there any background jobs, queues, or async processes?
- Are there any external APIs or third-party services to integrate?
- Any real-time requirements (websockets, push notifications, live updates)?
- What does a typical user request/flow look like end-to-end?
- Any significant caching, search, or storage requirements?

Ask until you can draw the system mentally: inputs → processing → storage → outputs.

---

### 5. Non-Functional Requirements

Goal: inform architecture decisions and identify early technical debt risks.

Ask only what's relevant:

- **Scale:** Expected users at launch vs. in 1 year? Concurrent users?
- **Performance:** Any latency requirements? Specific operations that must be fast?
- **Security:** PII or sensitive data? Compliance requirements (GDPR, HIPAA, SOC2)?
- **Availability:** Is downtime acceptable? SLA requirements?
- **Internationalization:** Multiple languages or locales?

---

### 6. Team & Conventions

Goal: fill the Conventions section of CLAUDE.md and set realistic sprint/backlog scope.

- How many developers? (solo, small team, larger team)
- Any existing conventions to preserve? (naming, file size limits, testing requirements)
- Code review process?
- What does "done" look like for a task? (tests required? code review? QA?)
- Are there any known constraints? (no external dependencies, must use company infra, etc.)

---

### 7. Build Phases

Goal: generate the BACKLOG.md and ACTIVE_CONTEXT.md with realistic phases.

After understanding the full scope, propose a phased plan and confirm with the user:

> "Based on what you've told me, here's how I'd sequence the build: [Phase 1: foundation, Phase 2: core features, Phase 3: ...]. Does this match your priorities, or would you sequence things differently?"

Wait for confirmation or adjustment before writing the files.

Typical phase patterns (adapt as needed):
- **Phase 1:** Foundation — auth, DB schema, core data models, project scaffolding
- **Phase 2:** Core Feature(s) — the primary user-facing functionality
- **Phase 3:** Supporting Features — secondary flows, admin, notifications, etc.
- **Phase 4:** Polish & Launch — error handling, performance, monitoring, deployment

Each phase should be independently shippable or at least testable.

---

### 8. Quick Commands

Goal: fill the Quick Commands table in CLAUDE.md.

Ask what commands they use for:
- Build
- Test
- Run (dev server or local execution)
- Lint / Format

If they're starting fresh and haven't set these up, use the framework's standard defaults and note them.

---

## Completion Check

Before ending the interview, run through this checklist mentally:

- [ ] Can I write a specific 2-3 sentence project overview?
- [ ] Do I know the full tech stack with no gaps?
- [ ] Do I understand the architecture well enough to write SYSTEM_MAP.md?
- [ ] Do I have enough entities/flows for a meaningful data model section?
- [ ] Do I know the build phases and can assign tasks to each?
- [ ] Do I have the project structure (folder layout)?
- [ ] Do I know the team conventions?
- [ ] Do I have the quick commands?

If any item is unchecked, ask the user before proceeding to file generation.
