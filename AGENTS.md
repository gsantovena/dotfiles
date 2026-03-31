# Repository Guidelines

## Project Structure & Module Organization
This repository manages environment configuration through symlinks. Core shell and Git files at the repo root are linked into `~/.*`, and `nvim/` is linked into `~/.config/nvim`. Use `install-dotfiles.sh` for simple linking and `scripts/install-enhanced.sh` for validation, backup, and verbose installs. Editor config lives in `nvim/` for Neovim and `vim/` for legacy support. Automation scripts are in `scripts/`, tests in `tests/`, and Git hooks under `git/templates/hooks/`.

## Build, Test, and Development Commands
Main workflows:

- `make check`: runs lint, security checks, and installation tests.
- `make test`: validates install behavior via `scripts/test-install.sh`.
- `make lint`: runs `shellcheck` across `*.sh` files when available.
- `make security`: checks for secret leaks and unsafe config patterns.
- `make install-dry`: previews symlink changes without modifying your home directory.
- `make install`: performs the full install with backup and verbose output.
- `make quick-install`: runs checks, then installs.
- `brew bundle --file=Brewfile`: installs the Homebrew-managed toolchain.

## Coding Style & Naming Conventions
Match the style of the file you edit instead of normalizing the repo. Shell scripts use Bash with `set -euo pipefail`, descriptive helper functions, and four-space indentation; Makefile recipes must stay tab-indented. Lua in `nvim/lua/` uses compact two-space indentation. Prefer kebab-case for scripts such as `install-enhanced.sh`, and keep test files in the `test_*.bats` pattern. Run `make lint` before submitting shell changes.

## Testing Guidelines
Primary coverage is in `tests/test_dotfiles.bats`, which checks script syntax, install validation, Git config parsing, and Neovim migration expectations. Add or update Bats tests whenever install behavior or validation logic changes. Before opening a PR, run `make check`; for focused work, use `bats tests/test_dotfiles.bats`, `git config --file gitconfig --list`, and `zsh -n zshrc`.

## Commit & Pull Request Guidelines
Recent history favors short, imperative commit subjects, with a scope prefix such as `docs:` when useful. Keep messages specific, for example: `docs: update install instructions` or `Force nvim to be the EDITOR.` PRs should explain the config change, list validation commands run, and note follow-up such as `brew bundle` or opening Neovim to install plugins. Include screenshots only for UI changes or documentation imagery.

## Security & Configuration Tips
Do not commit machine-specific secrets, tokens, or private paths unless they are already intentional repo conventions. Prefer environment variables for sensitive values and run `make security` after touching shell startup files, install scripts, or Git hooks. Installs create `~/.logs`, back up files under `~/.dotfiles-backup-*`, and replace `~/.vim` to avoid nested layouts.
