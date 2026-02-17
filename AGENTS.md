# AGENTS.md

This file provides guidance to AI coding agents when working with this repository.

## Repository Overview

Personal dotfiles repository (`petrubear/dotfiles`) with configs for **10 tools**, managed as a plain Git repo on the `master` branch. Configs are stored in per-tool directories and manually symlinked to `~/.config/`. There are no install scripts or automation frameworks (no stow, chezmoi, etc.). Neovim Lazy.nvim auto-bootstraps on first run; TMux requires manual TPM installation before plugins work.

## Repository Structure

```
dotfiles/
├── nvim/              # Neovim — primary editor (Lazy.nvim, 30 Lua files)
│   ├── init.lua              # Entry point → requires edison.lazy
│   ├── lazy-lock.json        # Plugin lockfile (gitignored)
│   └── lua/edison/
│       ├── core/
│       │   ├── init.lua      # Loads options + keymaps
│       │   ├── options.lua   # Editor settings (2-space indent, relative numbers, etc.)
│       │   └── keymaps.lua   # Global keymaps (leader = Space)
│       ├── lazy.lua          # Lazy.nvim bootstrap + setup
│       ├── lsp.lua           # LSP keymaps (gd, gR, K, etc.) + diagnostic signs
│       └── plugins/
│           ├── alpha.lua            # Dashboard
│           ├── autopairs.lua        # Auto-close brackets
│           ├── bufferline.lua       # Tab bar
│           ├── colorscheme.lua      # Dracula fallback (disabled)
│           ├── dracula.lua          # Active colorscheme
│           ├── dressing.lua         # Improved UI for vim.ui.select/input
│           ├── flash.lua            # Motion/jump
│           ├── formatting.lua       # Code formatting
│           ├── gitsigns.lua         # Git gutter signs
│           ├── indent-blankline.lua # Indent guides
│           ├── init.lua             # Misc plugin specs
│           ├── linting.lua          # Code linting
│           ├── lualine.lua          # Status line
│           ├── noice.lua            # UI for messages, cmdline, popupmenu
│           ├── nvim-cmp.lua         # Autocompletion engine
│           ├── nvim-tree.lua        # File explorer
│           ├── rainbow-delimiters.lua # Colored bracket pairs
│           ├── surround.lua         # Surround text objects
│           ├── telescope.lua        # Fuzzy finder
│           ├── treesitter.lua       # Syntax highlighting/parsing
│           ├── trouble.lua          # Diagnostics list
│           ├── which-key.lua        # Keymap hints
│           ├── yank.lua             # Yank enhancements
│           └── lsp/
│               ├── lsp.lua          # cmp-nvim-lsp capabilities
│               └── mason.lua        # LSP server installer
├── zsh/
│   └── zshrc                 # Primary shell config (131 lines)
├── ghostty/
│   ├── config                # Primary terminal emulator config
│   └── themes/               # Theme files (Dracula Pro, Van Helsing)
├── tmux/
│   └── tmux.conf             # Terminal multiplexer config
├── wezterm/
│   ├── wezterm.lua           # Entry point — composes ui.lua + keybinds.lua
│   ├── ui.lua                # Appearance settings
│   └── keybinds.lua          # Tmux-style key bindings
├── starship/
│   └── starship.toml         # Prompt config with custom Dracula palette
├── fish/
│   ├── config.fish           # Secondary shell entry point
│   ├── aliases.fish          # Aliases (mirrors zsh)
│   ├── conf.d/               # Auto-loaded config fragments
│   ├── completions/          # Custom completions
│   └── functions/            # Fish functions
├── zellij/
│   └── config.kdl            # Multiplexer alt to tmux (537 lines, full custom keybinds)
├── opencode/
│   ├── opencode.json         # Local LLM IDE config (LM Studio)
│   └── themes/dracula.json   # Custom Dracula theme for OpenCode
├── yazi/
│   └── yazi.toml             # File manager config (minimal)
├── CLAUDE.md                 # AI context for Claude Code
└── AGENTS.md                 # This file
```

## Neovim — Primary Editor

- **Plugin manager**: Lazy.nvim — auto-bootstraps by cloning itself on first run. Setup in `lua/edison/lazy.lua` imports both `edison.plugins` and `edison.plugins.lsp`.
- **Leader key**: `Space`
- **Colorscheme**: Dracula (`dracula.lua` is active, `colorscheme.lua` is `enabled = false` as a disabled fallback)
- **LSP**: `cmp-nvim-lsp` provides capabilities, Mason handles server installation, keymaps are defined via an `LspAttach` autocmd in `lsp.lua`. Key bindings: `gd` (definition), `gR` (references), `gi` (implementations), `K` (hover), `<leader>ca` (code action), `<leader>rn` (rename).
- **Diagnostic signs**: Custom icons — ` ` (error), ` ` (warn), `󰠠 ` (hint), ` ` (info)
- **20+ plugins**: Telescope (fuzzy finder), Treesitter (syntax), nvim-cmp (completion), nvim-tree (file explorer), Lualine (statusline), Bufferline (tabs), Gitsigns (git gutter), Flash (motions), Trouble (diagnostics list), Which-Key (keymap hints), Noice (UI), Dressing (improved selects), Autopairs, Surround, Rainbow Delimiters, Indent Blankline, Alpha (dashboard), formatting, linting, yank
- **Core options**: Relative line numbers, 2-space indentation, system clipboard (`unnamedplus`), smart case search, cursorline, undofile, no swapfile/backup, term gui colors, dark background, splitbelow/splitright
- **Window keymaps**: `<leader>sv` (vertical split), `<leader>sh` (horizontal split), `<leader>se` (equalize), `<leader>sx` (close split), tab management with `<leader>t{o,x,n,p,f}`

## Zsh — Primary Shell

- **Editor**: `nvim` set as `EDITOR`, `VISUAL`, `SUDO_EDITOR`, and `FCEDIT`
- **History**: 5000 lines, stored in `~/.zsh_history`, with full deduplication (`hist_ignore_all_dups`, `hist_save_no_dups`, `HISTDUP=erase`), shared across sessions (`sharehistory`)
- **Plugins (all via Homebrew)**:
  - `starship` — prompt
  - `zoxide` — smart directory jumping (aliased as `j`)
  - `fzf` — fuzzy finder
  - `zsh-syntax-highlighting` — command syntax colors
  - `zsh-autosuggestions` — fish-like suggestions
  - `zsh-vi-mode` — vi keybindings
  - `fzf-tab` — fzf-powered tab completion with directory preview
- **NVM**: Lazy-loaded via wrapper functions for `nvm`, `node`, `npm`, and `npx` that unset themselves and source NVM on first invocation
- **SDKMAN**: JVM language SDK management, sourced from `$HOME/.sdkman`
- **Modern CLI replacements**:
  - `eza` → `ls` (with icons) and `list` (detailed with git info)
  - `tspin` → `tail`
  - `kubecolor` → `kubectl`
  - `zoxide` → `cd` (aliased as `j`)
  - `thefuck` → `fk` (command correction)
- **Common aliases**: `c` (clear), `q`/`quit` (exit), `vi`/`vim` (nvim), safe `cp`/`mv`/`rm` with `-iv` flags
- **PATH order**: `/opt/homebrew/bin`, `~/.local/bin`, `~/.lmstudio/bin`, `~/.antigravity/antigravity/bin`
- **Keybinds**: `Ctrl-p`/`Ctrl-n` and arrow keys for history search backward/forward
- **Completion**: Case-insensitive, substring matching, no menu (fzf-tab handles it), `LS_COLORS` integration
- **Telemetry**: Claude and .NET telemetry explicitly disabled

## Ghostty — Primary Terminal Emulator

- **Theme**: Dracula Pro (loaded from external file `themes/pro`)
- **Font**: Monolisa Nerd Font, 16px, Medium weight, with ligatures enabled (`+calt`, `+liga`, `+dlig`)
- **Window**: Maximized on launch, hidden titlebar (`macos-titlebar-style = hidden`), 10px padding on all sides, no window state save
- **Shell integration**: Detects shell automatically, enables cursor/sudo/title features
- **Behavior**: Quit after last window closed, no close confirmation, block cursor with blinking, copy-on-select disabled
- **Keybinds**: Standard macOS (`⌘T` new tab, `⌘W` close, `⌘N` new window, `⌘[`/`⌘]` tab switching), `Shift+Enter` sends `\x1b\r`

## Tmux — Terminal Multiplexer

- **Prefix**: `Ctrl-a` (unbound `Ctrl-b`)
- **Theme**: Catppuccin Mocha with custom background `#22212C` and rounded window status
- **Status bar**: Top position, showing application name, directory, session, uptime, battery, and datetime
- **Plugins (via TPM)**:
  - `tmux-plugins/tmux-sensible` — sensible defaults
  - `tmux-plugins/tmux-yank` — clipboard integration (mouse yank disabled)
  - `tmux-plugins/tmux-resurrect` — session persistence
  - `catppuccin/tmux` — theme
  - `tmux-plugins/tmux-battery` — battery status module
- **Settings**: Vi mode keys, mouse enabled, 1M history, 1-indexed windows, renumber on close, system clipboard, zero escape delay
- **Navigation**: Vim-style `h/j/k/l` pane movement. Splits and new windows inherit `pane_current_path`
- **Reload**: `prefix + r` reloads config
- **Setup**: Requires manual TPM clone: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`, then `prefix + I` to install plugins

## WezTerm — Alternative Terminal Emulator

- **Config pattern**: Modular Lua — `wezterm.lua` is the entry point, composing `ui.lua` (appearance) and `keybinds.lua` (key bindings) via `apply_to_config(config)` pattern
- **Leader key**: `Ctrl-a` (matches tmux for muscle memory)
- **Keybinds**: Full tmux-style — `Leader + "` (vertical split), `Leader + %` (horizontal split), `Leader + h/j/k/l` (pane navigation), `Leader + H/J/K/L` (resize by 5), `Leader + 1-9` (tab switching), `Leader + c` (new tab), `Leader + o`/`z` (zoom toggle), `Leader + d`/`x` (close pane), `Leader + &` (close tab)

## Starship — Prompt

- **Palette**: Custom Dracula colors defined in `[palettes.dracula]` — pink `#ff79c6`, red `#ff5555`, yellow `#f1fa8c`, green `#50fa7b`, blue `#644ac9`, purple `#bd93f9`, cyan `#8be9fd`, comment `#6272a4`, base/mantle/crust for dark backgrounds
- **Segment order**: OS icon → username → directory → git branch/status → language versions → conda → time → cmd_duration
- **Powerline style**: Connected segments using foreground/background color transitions (e.g., `[](bg:cyan fg:purple)`)
- **Language detection**: Node.js, C, Rust, Go, PHP, Java, Kotlin, Haskell, Python — each with Nerd Font icons
- **Vi-mode indicators**: `❯` (normal/insert), `❮` (command/visual), with color changes for replace and visual modes
- **Directory**: Truncated to 3 segments, with icon substitutions for Documents, Downloads, Music, Pictures, Developer
- **Cmd duration**: Shows milliseconds, desktop notification after 45 seconds
- **Line break**: Disabled (single-line prompt)

## Fish — Secondary Shell

- Minimal config — just zoxide, starship init, and aliases sourced from `aliases.fish`
- Mirrors zsh aliases for consistency when switching shells
- Has `conf.d/`, `completions/`, and `functions/` directories for extensibility

## Zellij — Alternative Multiplexer

- **537 lines** of fully customized keybinds with `clear-defaults=true`
- **Theme**: Dracula
- **Tmux compatibility mode**: `Ctrl-b` prefix triggers tmux-like bindings (splits with `"`/`%`, tab with `c`/`n`/`p`, vim navigation, zoom with `z`)
- **Mode-based keybinds**: Separate key maps for locked, pane, tab, resize, move, scroll, search, session, and tmux modes
- **Navigation**: Vi-style `h/j/k/l` in all relevant modes plus arrow key alternatives
- **Global binds** (outside locked mode): `Alt+h/j/k/l` for focus, `Alt+f` for floating panes, `Alt+n` for new pane, `Alt+[`/`]` for swap layouts, `Ctrl+g` to lock, `Ctrl+q` to quit
- **Startup tips**: Disabled
- **Web font**: monospace

## OpenCode — Local LLM IDE

- **Provider**: LM Studio running locally at `127.0.0.1:1234`
- **Model**: `openai/gpt-oss-20b`
- **MCP**: Context7 integration with API key loaded from `~/.config/secrets/context7`
- **Theme**: Dracula (custom theme in `themes/dracula.json`)

## Yazi — File Manager

- Minimal config (25 bytes in `yazi.toml`)

## Design Conventions

| Convention | Details |
|---|---|
| **Theme** | Dracula everywhere (Ghostty, Starship, WezTerm, Neovim, Zellij, OpenCode). Tmux is the exception with Catppuccin Mocha |
| **Font** | Monolisa Nerd Font, 16px, across all terminal emulators |
| **Vi mode** | Enabled in zsh, tmux, Neovim, zellij, and starship prompt indicators |
| **Prefix/Leader** | `Ctrl-a` in tmux and WezTerm; `Space` in Neovim; `Ctrl-b` in zellij tmux-compat mode |
| **Indentation** | 2 spaces universally |
| **Commit style** | Conventional commits (`feat:`, `fix:`) |
| **Module namespace** | Neovim Lua modules live under `edison/` (e.g., `require("edison.core.keymaps")`) |
| **CLI philosophy** | Replace coreutils with modern Rust/Go alternatives (eza, tspin, zoxide, kubecolor) |
| **Editor** | `nvim` aliased and exported everywhere — `vi`, `vim`, `EDITOR`, `VISUAL`, `SUDO_EDITOR`, `FCEDIT` |
| **Safety aliases** | `cp`, `mv`, `rm` wrapped with interactive + verbose flags (`-iv`) |
| **Plugin sources** | Neovim via Lazy.nvim, tmux via TPM, zsh via Homebrew, zellij built-in |
| **Config deployment** | Manual symlinks to `~/.config/` — no stow, chezmoi, or install scripts |

## File Patterns

- **Neovim plugins**: Each file in `lua/edison/plugins/` returns a single Lazy.nvim spec table: `return { "author/plugin", config = function() ... end }`
- **WezTerm modules**: Each file exports `{ apply_to_config = function(config) ... end }`, composed in the entry point
- **Zsh sections**: Organized with fold markers (`# section {` / `# }`) for editor navigation
- **Ghostty config**: Flat key-value pairs with comments. Themes loaded via `config-file = themes/<name>`
- **Zellij config**: KDL format with nested keybind blocks per mode

## Design Decisions

1. **Dracula Pro (paid theme)**: `nvim/lua/edison/plugins/dracula.lua` points to a local `dir` path (`stdpath("data") .. "/site/pack/themes/start/dracula_pro"`) because Dracula Pro is a paid theme that must be manually installed — this is expected and not a bug.
2. **Fallback colorscheme**: `nvim/lua/edison/plugins/colorscheme.lua` is intentionally kept with `enabled = false` as a fallback for machines where Dracula Pro is not installed. Do not remove this file.
3. **Latest plugins preferred**: `lazy-lock.json` is gitignored on purpose — the intent is to always run the latest version of all Neovim plugins rather than pin specific versions.

## Recently Fixed

1. ✅ **Tmux plugin typo**: Fixed in `tmux/tmux.conf` line 43 — now correctly uses `tmux-plugins/tmux-resurrect`
2. ✅ **Duplicate Neovim options**: Fixed in `nvim/lua/edison/core/options.lua` — `splitbelow` and `splitright` now only appear once (lines 28-29)
3. ✅ **Duplicate Ghostty setting**: Fixed in `ghostty/config` — `macos-titlebar-style` now only appears once (line 21)
4. ✅ **Deprecated Neovim API**: Fixed in `nvim/lua/edison/lazy.lua` and `nvim/lua/edison/plugins/linting.lua` — now uses `vim.uv` instead of `vim.loop`
5. ✅ **Deprecated zsh variable**: Removed `GREP_OPTIONS` export from `zsh/zshrc`
6. ✅ **Autogenerated zellij comment**: Removed autogenerated header from `zellij/config.kdl`

## .gitignore

Excluded from version control: `.DS_Store`, `lazy-lock.json`, `zellij/config.kdl.bak`, `fish/fish_variables`, `fish/**/*.local.fish`, `.claude/`, `.vscode/`
