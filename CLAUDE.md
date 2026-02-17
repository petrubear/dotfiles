# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal dotfiles repository (`petrubear/dotfiles`) managed as a plain Git repo on the `master` branch. Configs are stored in per-tool directories and manually symlinked to `~/.config/`. There are no install scripts or automation frameworks (no stow, chezmoi, etc.).

## Structure

- **nvim/** — Neovim config using Lazy package manager (auto-bootstraps). Plugins defined in `lua/edison/plugins/`, LSP setup in `lua/edison/lsp/`, core settings/keymaps in `lua/edison/core/`.
- **zsh/zshrc** — Primary shell. Uses Homebrew-installed plugins (zsh-syntax-highlighting, zsh-autosuggestions, zsh-vi-mode, fzf-tab). Lazy-loads NVM. Integrates starship, zoxide, fzf.
- **tmux/tmux.conf** — Prefix is `Ctrl-a`. Catppuccin Mocha theme. Requires TPM: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`, then `prefix + I`.
- **ghostty/** — Primary terminal emulator. Dracula Pro theme. Monolisa Nerd Font.
- **wezterm/** — Alternative terminal. Entry point `wezterm.lua` composes `ui.lua` + `keybinds.lua`.
- **starship/starship.toml** — Prompt config with Dracula color palette.
- **fish/** — Secondary shell config mirroring zsh aliases.
- **zellij/config.kdl** — Terminal multiplexer alternative to tmux.
- **opencode/opencode.json** — Local LLM IDE config (LM Studio provider).

## Conventions

- **Theme**: Dracula everywhere (Ghostty, Starship, WezTerm, Neovim, OpenCode). Tmux uses Catppuccin Mocha.
- **Font**: Monolisa Nerd Font, 16px, across all terminal emulators.
- **Vi mode**: Enabled in zsh, tmux, neovim, and zellij.
- **Indentation**: 2 spaces (Neovim `tabstop=2`, `shiftwidth=2`).
- **Neovim namespace**: All Lua modules live under `edison/` (e.g., `require("edison.core.keymaps")`).
- **Commit style**: Conventional commits (`feat:`, `fix:`).
