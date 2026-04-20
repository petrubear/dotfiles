---
inclusion: always
---

# RTK (Rust Token Killer) — Token-Optimized Command Proxy

RTK is installed on this machine. It compresses CLI output by 60–90% before it reaches your context window, enabling longer sessions and lower token usage.

**Always prefix the commands listed below with `rtk` instead of running them directly.**

---

## Git

```
rtk git status          # instead of: git status
rtk git log             # instead of: git log
rtk git log -n 10       # instead of: git log -n 10
rtk git diff            # instead of: git diff
rtk git diff <file>     # instead of: git diff <file>
rtk git add <path>      # instead of: git add <path>
rtk git commit -m "msg" # instead of: git commit -m "msg"
rtk git push            # instead of: git push
rtk git pull            # instead of: git pull
rtk git branch          # instead of: git branch
```

## GitHub CLI (gh)

```
rtk gh pr list          # instead of: gh pr list
rtk gh pr view <n>      # instead of: gh pr view <n>
rtk gh issue list       # instead of: gh issue list
rtk gh issue view <n>   # instead of: gh issue view <n>
rtk gh run list         # instead of: gh run list
rtk gh run view <n>     # instead of: gh run view <n>
```

## File System

```
rtk ls .                # instead of: ls
rtk ls <path>           # instead of: ls <path>
rtk tree <path>         # instead of: tree <path>
rtk find "<pattern>" .  # instead of: find . -name "<pattern>"
rtk grep "pattern" .    # instead of: grep -r "pattern" .
rtk read <file>         # instead of: cat <file>
rtk read <file> -l aggressive  # signatures only (strips function bodies)
rtk wc <file>           # instead of: wc <file>
rtk diff <file1> <file2>       # instead of: diff <file1> <file2>
```

## JavaScript / Node

```
rtk npm install         # instead of: npm install
rtk npm test            # instead of: npm test
rtk npm run <script>    # instead of: npm run <script>
rtk npx <cmd>           # instead of: npx (routes tsc/eslint/prisma to specialized filters)
rtk pnpm install        # instead of: pnpm install
rtk pnpm list           # instead of: pnpm list
rtk pnpm test           # instead of: pnpm test
rtk pnpm run <script>   # instead of: pnpm run <script>
```

## Build & Lint

```
rtk tsc                 # instead of: tsc (TypeScript errors grouped by file)
rtk next build          # instead of: next build
rtk lint                # instead of: eslint / biome / etc.
rtk lint biome          # explicitly target biome
rtk prettier --check .  # instead of: prettier --check .
rtk format              # universal format checker (prettier, black, ruff format)
```

## Testing

```
rtk vitest run          # instead of: vitest run
rtk jest                # instead of: jest (compact output)
rtk playwright test     # instead of: playwright test
```

## Rust / Cargo

```
rtk cargo build         # instead of: cargo build
rtk cargo build --release
rtk cargo test          # instead of: cargo test (failures only)
rtk cargo check         # instead of: cargo check
rtk cargo clippy        # instead of: cargo clippy
```

## Python

```
rtk pytest              # instead of: pytest (failures only)
rtk ruff check .        # instead of: ruff check .
rtk mypy .              # instead of: mypy (errors grouped by file)
rtk pip install <pkg>   # instead of: pip install (auto-detects uv)
```

## Ruby / Rails

```
rtk rspec               # instead of: rspec (compact output)
rtk rubocop             # instead of: rubocop (compact violations)
rtk rake test           # instead of: rake test (compact Minitest output)
```

## Go

```
rtk go build            # instead of: go build
rtk go test             # instead of: go test
rtk golangci-lint run   # instead of: golangci-lint run
```

## .NET

```
rtk dotnet build        # instead of: dotnet build
rtk dotnet test         # instead of: dotnet test
rtk dotnet restore      # instead of: dotnet restore
rtk dotnet format       # instead of: dotnet format
```

## Docker / Kubernetes

```
rtk docker ps           # instead of: docker ps
rtk docker compose up   # instead of: docker compose up
rtk docker compose down # instead of: docker compose down
rtk kubectl get pods    # instead of: kubectl get pods
rtk kubectl get <resource>
```

## AWS

```
rtk aws <cmd>           # instead of: aws (forces JSON, compresses output)
```

## Database

```
rtk psql <args>         # instead of: psql (strips borders, compresses tables)
rtk prisma generate     # instead of: prisma generate
rtk prisma migrate dev --name <name>
rtk prisma db push      # instead of: prisma db push
```

## Network

```
rtk curl <url>          # instead of: curl (auto JSON detection + schema output)
rtk wget <url>          # instead of: wget (strips progress bars)
```

## Graphite

```
rtk gt <cmd>            # instead of: gt (stacked PR commands)
```

## Logs & Output Filtering

```
rtk log <file>          # filter and deduplicate log output
rtk err <cmd>           # run command and show only errors/warnings
rtk summary <cmd>       # run command and show heuristic summary
rtk json <file>         # show JSON compact; --schema for schema-only
rtk pipe                # read stdin, apply filter, print filtered output (Unix pipe mode)
```

## RTK Meta Commands

```
rtk gain                # show total token savings stats
rtk gain --graph        # savings over time (ASCII graph)
rtk gain --history      # per-command history
rtk smart <file>        # 2-line heuristic summary of a code file
rtk deps                # summarize project dependencies
rtk env                 # show env vars (filtered, sensitive masked)
rtk proxy <any-cmd>     # passthrough with tracking but no compression
rtk run <cmd>           # execute via sh -c (raw, no filtering or tracking)
rtk discover            # discover missed RTK savings from history
rtk session             # show RTK adoption across sessions
rtk learn               # learn CLI corrections from error history
rtk cc-economics        # spending (ccusage) vs savings (rtk) analysis
rtk rewrite <cmd>       # rewrite a raw command to its RTK equivalent
rtk config              # show or create configuration file
rtk telemetry           # manage telemetry consent (GDPR)
rtk trust               # trust project-local TOML filters in current directory
rtk untrust             # revoke trust for project-local TOML filters
rtk verify              # verify hook integrity and run TOML filter inline tests
```

---

## Rules

1. **Always use `rtk <cmd>` for any command in the lists above.** Do not run the raw command.
2. **For commands not listed**, run them normally — RTK will passthrough transparently via `rtk proxy <cmd>` if needed.
3. **Never re-run a command just to get unfiltered output.** If you need the full output of a failed command, check `~/.local/share/rtk/tee/` — RTK saves raw output for failures automatically.
4. **Do not install RTK.** It is already installed. Verify with `rtk gain` if uncertain.
