# Zsh

Primary shell configuration. All plugins are installed via Homebrew. The config uses fold markers (`# section {` / `# }`) for editor navigation.

## Dependencies

- `starship` -- prompt (`brew install starship`)
- `zoxide` -- smart directory jumping (`brew install zoxide`)
- `fzf` -- fuzzy finder (`brew install fzf`)
- `zsh-syntax-highlighting` -- command syntax colors (`brew install zsh-syntax-highlighting`)
- `zsh-autosuggestions` -- fish-like suggestions (`brew install zsh-autosuggestions`)
- `zsh-vi-mode` -- vi keybindings (`brew install zsh-vi-mode`)
- `fzf-tab` -- fzf-powered tab completion (`brew install fzf-tab`)
- `zsh-completions` -- additional completions (`brew install zsh-completions`)
- `neovim` -- editor (`brew install neovim`)
- `eza` -- modern ls replacement (`brew install eza`)
- `kubecolor` -- colored kubectl output (`brew install kubecolor`)
- `thefuck` -- command correction (`brew install thefuck`)
- `nvm` -- Node.js version manager (`brew install nvm`)
- `sdkman` -- JVM SDK manager (installed separately, see https://sdkman.io)

## Plugins

| Plugin | Source | Purpose |
|--------|--------|---------|
| starship | `eval "$(starship init zsh)"` | Cross-shell prompt |
| zoxide | `eval "$(zoxide init zsh)"` | Smart directory jumping (aliased as `j`) |
| fzf | `eval "$(fzf --zsh)"` | Fuzzy finder integration |
| zsh-syntax-highlighting | Homebrew source | Command syntax coloring |
| zsh-autosuggestions | Homebrew source | Fish-like inline suggestions |
| zsh-vi-mode | Homebrew source | Vi keybindings for the shell |
| fzf-tab | Homebrew source | FZF-powered tab completion with directory preview |
| zsh-completions | Homebrew FPATH | Additional completion definitions |

## Aliases

| Alias | Expands To | Purpose |
|-------|-----------|---------|
| `vi`, `vim` | `nvim` | Use Neovim everywhere |
| `ls` | `eza --icons` | Modern ls with icons |
| `list` | `eza -bghl --git --icons --color=automatic` | Detailed listing with git info |
| `j` | `z` (zoxide) | Smart directory jump |
| `kubectl` | `kubecolor` | Colored kubectl output |
| `fk` | `thefuck` | Command correction |
| `c` | `clear` | Quick clear |
| `q`, `quit` | `exit` | Quick exit |
| `cp` | `cp -iv` | Safe copy (interactive, verbose) |
| `mv` | `mv -iv` | Safe move (interactive, verbose) |
| `rm` | `rm -iv` | Safe remove (interactive, verbose) |
| `mkdir` | `mkdir -pv` | Create parents, verbose |
| `rmdir` | `rmdir -v` | Verbose rmdir |
| `more` | `less` | Use less instead of more |
| `rg` | `rg --smart-case --hidden` | Ripgrep with smart case and hidden files |

Note: Aliases are sourced from `~/.zsh_alias` (external file, not in this repo). The `tspin` alias for `tail` is currently commented out.

## Environment Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `EDITOR` | `nvim` | Default editor |
| `VISUAL` | `nvim` | Visual editor |
| `SUDO_EDITOR` | `nvim` | Sudo editor |
| `FCEDIT` | `nvim` | fc command editor |
| `HOMEBREW_NO_ENV_HINTS` | `1` | Suppress Homebrew hints |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC` | `true` | Disable Claude telemetry |
| `CLAUDE_TELEMETRY_ENABLED` | `false` | Disable Claude telemetry |
| `DOTNET_CLI_TELEMETRY_OPTOUT` | `1` | Disable .NET telemetry |
| `SHELL_SESSIONS_DISABLE` | `1` | Disable macOS shell session restoration |

## PATH Order

1. `/opt/homebrew/bin`
2. `~/.local/bin`
3. `~/.lmstudio/bin`
4. `~/.antigravity/antigravity/bin`

## History

- `HISTSIZE`: 5000 lines
- `HISTFILE`: `~/.zsh_history`
- Full deduplication: `hist_ignore_all_dups`, `hist_save_no_dups`, `HISTDUP=erase`
- Shared across sessions: `sharehistory`
- Ignore commands starting with space: `hist_ignore_space`

## NVM Lazy-Loading

NVM is lazy-loaded for faster shell startup. Wrapper functions for `nvm`, `node`, `npm`, and `npx` unset themselves and source NVM on first invocation, then delegate to the real command.

## SDKMAN

SDKMAN is sourced from `$HOME/.sdkman/bin/sdkman-init.sh` if present, for managing Java, Kotlin, Gradle, and other JVM SDK versions.

## Kiro CLI Integration

Pre and post hooks are sourced from `~/Library/Application Support/kiro-cli/shell/` at the top and bottom of the zshrc respectively.

## Secrets

`~/.zsh_secrets` is sourced if present, for tokens and API keys. This file is not tracked in version control.

## Keybindings

| Keybind | Action |
|---------|--------|
| `Ctrl-p` | History search backward |
| `Ctrl-n` | History search forward |
| `Up Arrow` | History search backward |
| `Down Arrow` | History search forward |

## Completion

- Case-insensitive and substring matching
- No menu (fzf-tab handles completion UI)
- `LS_COLORS` integration for colored completions
- `cd` completions show directory preview via fzf

## Shell Options

`GLOB_COMPLETE`, `appendhistory`, `autocd`, `correct`, `interactivecomments`, `magicequalsubst`, `nonomatch`, `notify`, `numericglobsort`, `promptsubst`, `sharehistory`
