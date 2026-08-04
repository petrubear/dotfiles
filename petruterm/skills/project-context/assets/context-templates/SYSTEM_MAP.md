# System Map

**Last Updated:** [Date]
**Architecture Pattern:** [e.g., Layered MVC, Hexagonal, Event-Driven, Monolith, Microservices]

## System Overview
[3-5 sentences describing the overall system: what it does, how its major parts connect,
and the key design decisions that shape the architecture.]

---

## Component Map

```
[Diagram of components and their relationships — use ASCII art or describe as a tree]

Example:
Client (Browser / Mobile)
    │
    ▼
[API Layer] ── Auth Middleware ──► [Auth Provider]
    │
    ├──► [Feature Module A]
    │         └──► [Database]
    │
    └──► [Feature Module B]
              ├──► [Database]
              └──► [External API]
```

---

## Components

### [Component Name]
- **Type:** [API / Service / UI / Worker / Database / Cache / External]
- **Responsibility:** [What this component does in one sentence]
- **Technology:** [Specific library/framework/service used]
- **Interfaces:**
  - Input: [What it receives]
  - Output: [What it produces]
- **Dependencies:** [Other components it calls]

### [Component Name]
- **Type:** [type]
- **Responsibility:** [description]
- **Technology:** [technology]
- **Interfaces:**
  - Input: [input]
  - Output: [output]
- **Dependencies:** [dependencies]

---

## Data Model

### [Entity Name]
| Field | Type | Description |
|-------|------|-------------|
| id | [type] | Primary key |
| [field] | [type] | [description] |
| [field] | [type] | [description] |
| created_at | timestamp | Creation timestamp |
| updated_at | timestamp | Last modification |

### [Entity Name]
| Field | Type | Description |
|-------|------|-------------|
| id | [type] | Primary key |
| [field] | [type] | [description] |

### Relationships
- [Entity A] has many [Entity B]
- [Entity B] belongs to [Entity A]
- [Entity A] and [Entity C] are many-to-many via [join table]

---

## Key Flows

### [Flow Name — e.g., "User Registration"]
```
1. [Step 1 — actor and action]
2. [Step 2]
3. [Step 3]
4. [Step 4 — final state]
```

### [Flow Name — e.g., "Core Feature Happy Path"]
```
1. [Step 1]
2. [Step 2]
3. [Step 3]
```

---

## External Integrations

| Service | Purpose | Auth Method | Notes |
|---------|---------|-------------|-------|
| [Service name] | [What it's used for] | [API key / OAuth / webhook] | [Rate limits, gotchas] |

---

## Infrastructure

- **Hosting:** [e.g., Vercel, AWS, Railway, self-hosted]
- **Database Hosting:** [e.g., Supabase, RDS, PlanetScale]
- **CDN / Static Assets:** [e.g., Cloudflare, S3, none]
- **CI/CD:** [e.g., GitHub Actions, CircleCI]
- **Monitoring:** [e.g., Sentry, Datadog, none]
- **Environments:** [e.g., local → staging → production]

---

## Architecture Decisions

| Decision | Choice | Rationale | Alternatives Considered |
|----------|--------|-----------|------------------------|
| [Decision 1] | [What was chosen] | [Why] | [What else was considered] |
| [Decision 2] | [What was chosen] | [Why] | [What else was considered] |
