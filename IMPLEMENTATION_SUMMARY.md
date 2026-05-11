# Dotfiles Implementation Summary

## Current Architecture

This repository manages a personal development environment with symlinked home
files and `~/.config` directories. The installer backs up existing targets before
linking and the test suite verifies syntax, install behavior, and key config
contracts.

## Shell

- `zshrc` is a thin entrypoint that loads `zsh/*.zsh` in lexical order.
- `zsh/00-zinit.zsh` bootstraps zinit, loads Zsh plugins/snippets, and initializes
  Oh My Posh when available.
- `ohmyposh/` contains tracked prompt themes linked to `~/.config/ohmyposh`.
- Shared aliases, exports, and functions are sourced from `zsh/10-shared-shell.zsh`.

## Editor

- Neovim is the only tracked editor configuration.
- `nvim/init.vim` delegates behavior to Lua modules under `nvim/lua/config` and
  plugin specs under `nvim/lua/plugins`.
- lazy.nvim owns plugin management.

## Terminal

- `tmux/` is linked to `~/.config/tmux`.
- The installer can bootstrap TPM unless `DOTFILES_SKIP_TPM_BOOTSTRAP` is set.
- `ghostty/` is linked to `~/.config/ghostty`.

## Automation

- `Makefile` exposes the main workflows: `make check`, `make test`,
  `make test-bats`, `make lint`, `make security`, and install variants.
- `scripts/install-enhanced.sh` handles validation, backup, symlink creation,
  install verification, and TPM bootstrap.
- `scripts/test-install.sh` exercises dry-run and real install behavior in a
  temporary home directory.
- `tests/test_dotfiles.bats` protects install contracts and configuration shape.

## Validation Baseline

Run before merging changes:

```bash
make check
```

Useful focused checks:

```bash
zsh -n zshrc
zsh -n zsh/*.zsh
git config --file gitconfig --list
oh-my-posh init zsh --config ohmyposh/zen.toml
```

## Known Tradeoffs

- The Brewfile is intentionally broad and personal; package pruning should be a
  separate usage audit, not incidental cleanup.
- Some startup integrations are optional and guarded so a fresh machine can run
  before every Homebrew package is installed.
- The security scan warns on tracked email configuration; decide separately
  whether to keep explicit git identity or move it to machine-local config.
