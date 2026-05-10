# Dotfiles Improvement Plan

This repository already has a solid baseline: a symlink installer with backups,
Bats coverage, shell syntax checks, a security scan, and GitHub Actions on macOS
and Ubuntu. The remaining work should stay incremental and test-backed.

## Current Baseline

- `make check` runs lint, security checks, installation tests, and Bats tests.
- `scripts/install-enhanced.sh` validates, backs up, links home files, links
  config directories, and bootstraps TPM when enabled.
- `zshrc` is a thin loader for `zsh/*.zsh` modules.
- Zsh plugins are managed by zinit; the prompt is managed by Oh My Posh from
  `ohmyposh/`.
- Neovim is the only tracked editor runtime and uses lazy.nvim modules.
- Tmux and Ghostty configs are tracked under `~/.config/` symlink targets.

## Recommended Next Improvements

### 1. Split install metadata from shell script constants

**Why:** `HOME_FILES` and `CONFIG_FILES` are embedded in
`scripts/install-enhanced.sh`, while tests duplicate expectations.

**Plan:**
1. Add a small manifest file, for example `install-manifest.json` or
   `install-manifest.sh`.
2. Have the installer and Bats tests read the same manifest.
3. Keep the first version simple: just home files and config directories.

**Validation:** `make check` plus one focused test that the manifest drives both
backup and link behavior.

### 2. Add optional component install selection

**Why:** Some machines may not need every config directory or every Homebrew
package.

**Plan:**
1. Add installer flags such as `--only nvim,zsh` or `--skip tmux`.
2. Keep default behavior unchanged.
3. Add Bats coverage for one `--only` and one `--skip` path.

**Validation:** `make test-bats` and `make install-dry`.

### 3. Improve shell startup observability

**Why:** zinit bootstrap and optional tool init happen during shell startup;
failures can otherwise be hard to diagnose.

**Plan:**
1. Add a lightweight `zsh/README.md` documenting module order and ownership.
2. Add a `make doctor-shell` target or script that checks zinit, Oh My Posh,
   fzf, zoxide, and linked config paths.
3. Keep shell startup quiet; put diagnostics in explicit doctor commands.

**Validation:** zsh syntax checks plus a new script syntax test.

### 4. Rationalize Homebrew package groups

**Why:** The Brewfile is comprehensive but hard to scan.

**Plan:**
1. Group packages with comments: core CLI, shell UX, cloud/Kubernetes, editor,
   languages, casks, VS Code extensions, uv tools.
2. Avoid deleting packages in the cleanup pass; make removals separately after
   usage review.
3. Consider a generated package inventory doc if the Brewfile keeps growing.

**Validation:** `brew bundle check --file=Brewfile` when available, otherwise
`make check`.

### 5. Add security-scan fixtures

**Why:** The scan now ignores `.git/` internals and reports tracked config
findings, but it would be easier to maintain with explicit fixtures.

**Plan:**
1. Add small tracked test fixtures for safe and unsafe patterns.
2. Assert tracked-file findings stay visible while ignored/internal files stay quiet.
3. Keep security output concise so real findings are easy to notice.

**Validation:** `make security` and focused Bats coverage for tracked vs ignored paths.

## Deferred / Not Recommended Yet

- **Full cross-platform package abstraction:** useful only if Linux setup becomes
  a regular workflow; otherwise it adds maintenance overhead.
- **Encrypted secrets framework:** add only when this repo needs to track secret
  templates or machine-specific encrypted material. Prefer environment variables
  for now.
- **Aggressive plugin pruning:** audit usage first; do not remove editor, tmux,
  or Brewfile packages as part of cosmetic cleanup.
