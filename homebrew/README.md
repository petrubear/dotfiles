# Homebrew

Brewfile package manifest for reproducible macOS setup. Contains all brews, casks, and taps needed to bootstrap a development environment.

## Dependencies

- [Homebrew](https://brew.sh/) -- macOS package manager

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Installation

Install all packages from the Brewfile:

```sh
cd ~/dotfiles/homebrew && brew bundle
```

Or specify the file path explicitly:

```sh
brew bundle --file=~/dotfiles/homebrew/Brewfile
```

## Taps

| Tap | Purpose |
|-----|---------|
| `anchore/grype` | Container vulnerability scanner |
| `dart-lang/dart` | Dart programming language |
| `hidetatz/tap` | Community formulae |
| `homebrew/core` | Default Homebrew core formulae |
| `homebrew/services` | Manage background services |
| `instrumenta/instrumenta` | Infrastructure tools |
| `steipete/tap` | `summarize` CLI tool |
| `tilt-dev/tap` | Tilt local Kubernetes development |

## Brews

### Editors and Shells

| Package | Description |
|---------|-------------|
| `neovim` | Primary editor |
| `vim` | Fallback editor |
| `zsh` | Primary shell |
| `fish` | Secondary shell |
| `bash` | Additional shell |
| `bash-completion` | Bash tab completions |

### Shell Plugins and Prompt

| Package | Description |
|---------|-------------|
| `starship` | Cross-shell prompt |
| `zsh-autosuggestions` | Fish-like suggestions for zsh |
| `zsh-completions` | Additional zsh completions |
| `zsh-syntax-highlighting` | Command syntax coloring for zsh |
| `zsh-vi-mode` | Vi keybindings for zsh |
| `fzf` | Fuzzy finder |
| `fzf-tab` | fzf-powered tab completion |
| `zoxide` | Smart directory jumping |
| `thefuck` | Command correction |

### Terminal Multiplexers

| Package | Description |
|---------|-------------|
| `tmux` | Terminal multiplexer |
| `zellij` | Alternative terminal multiplexer |

### Modern CLI Replacements

| Package | Replaces | Description |
|---------|----------|-------------|
| `eza` | `ls` | Modern file listing with icons and git info |
| `bat` | `cat` | Syntax-highlighted file viewer |
| `ripgrep` | `grep` | Fast recursive search |
| `fd` | `find` | User-friendly file finder |
| `dust` | `du` | Intuitive disk usage viewer |
| `procs` | `ps` | Modern process viewer |
| `git-delta` | `diff` | Enhanced git diff pager |
| `tailspin` | `tail` | Log file highlighter |

### System Monitoring

| Package | Description |
|---------|-------------|
| `btop` | Resource monitor (CPU, memory, disk, network) |
| `htop` | Interactive process viewer |

### Git and Version Control

| Package | Description |
|---------|-------------|
| `git` | Version control |
| `git-lfs` | Git Large File Storage |
| `lazygit` | TUI git client |
| `pre-commit` | Git pre-commit hook framework |
| `jj` | Jujutsu version control |

### Container and Kubernetes

| Package | Description |
|---------|-------------|
| `podman` | Container engine (Docker alternative) |
| `lazydocker` | TUI Docker/container management |
| `minikube` | Local Kubernetes cluster |
| `kubernetes-cli` | `kubectl` command-line tool |
| `kubecolor` | Colorized kubectl output |
| `octant` | Kubernetes dashboard |
| `tilt-dev/tap/tilt` | Local Kubernetes development |

### Language Tools

| Package | Description |
|---------|-------------|
| `nvm` | Node.js version manager |
| `ruby` | Ruby programming language |
| `uv` | Fast Python package manager |
| `ktlint` | Kotlin linter |
| `swiftformat` | Swift code formatter |
| `swiftlint` | Swift linter |
| `vapor` | Swift web framework CLI |
| `xcodegen` | Xcode project generator |

### Linting and Formatting

| Package | Description |
|---------|-------------|
| `shellcheck` | Shell script linter |
| `shfmt` | Shell script formatter |
| `actionlint` | GitHub Actions workflow linter |
| `ktlint` | Kotlin linter/formatter |
| `swiftformat` | Swift formatter |
| `swiftlint` | Swift linter |

### AI and LLM Tools

| Package | Description |
|---------|-------------|
| `opencode` | Local LLM IDE |
| `gemini-cli` | Google Gemini CLI |

### Networking and Cloud

| Package | Description |
|---------|-------------|
| `azure-cli` | Microsoft Azure CLI |
| `httpie` | User-friendly HTTP client |
| `wget` | File downloader |
| `mole` | SSH tunnel manager |

### Security

| Package | Description |
|---------|-------------|
| `grype` | Container vulnerability scanner |

### File Management and Utilities

| Package | Description |
|---------|-------------|
| `yazi` | Terminal file manager |
| `tree` | Directory tree viewer |
| `glow` | Markdown renderer for terminal |
| `gallery-dl` | Image/video gallery downloader |
| `simdjson` | Fast JSON parser |
| `beads` | Text processing tool |
| `steipete/tap/summarize` | Text summarization CLI |
| `docker-completion` | Docker shell completions |

## Casks

| Cask | Description |
|------|-------------|
| `ghostty` | GPU-accelerated terminal emulator |
| `claude-code` | Claude AI coding assistant |
| `codex` | OpenAI Codex CLI |
| `dotnet-sdk` | .NET SDK |
| `flutter` | Cross-platform UI framework |
| `swiftformat-for-xcode` | SwiftFormat Xcode plugin |
| `syntax-highlight` | macOS Quick Look syntax highlighting |
