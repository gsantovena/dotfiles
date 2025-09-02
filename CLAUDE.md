# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal dotfiles repository for managing development environment configurations across machines. The repository uses symbolic linking to maintain consistent shell, editor, and git configurations.

## Key Commands

### Installation & Setup
- `make install` - Full installation with backup and validation
- `make install-dry` - Dry run to preview changes without making them
- `make check` - Run all quality checks (lint, security, test)
- `make quick-install` - Run checks then install (comprehensive setup for new systems)
- `./scripts/install-enhanced.sh --help` - See all installation options

### Development & Quality Assurance
- `make test` - Run installation validation tests using bats framework
- `make lint` - Shell script linting with shellcheck
- `make security` - Run security validation checks
- `make clean` - Clean test artifacts

### Backup & Recovery
- `make backup` - Create backup of current configurations
- `./scripts/install-enhanced.sh --backup --verbose` - Install with explicit backup

## Architecture & Structure

### Core Installation System
- **Primary script**: `install-dotfiles.sh` - Simple symbolic linking
- **Enhanced script**: `scripts/install-enhanced.sh` - Full-featured with validation, backup, error handling
- **Makefile**: Provides convenient targets for common operations

### Configuration Categories
- **HOME_FILES**: `bash_profile aliases exports functions git gitconfig vim zshrc screenrc` - Linked to `~/.*`
- **CONFIG_FILES**: `nvim` - Linked to `~/.config/*`

### File Organization
- Shell configurations: `zshrc`, `bash_profile`, `aliases`, `exports`, `functions`
- Editor configurations: `nvim/` (primary), `vim/` (legacy support)
- Git setup: `gitconfig`, `git/templates/hooks/`
- Package management: `Brewfile` for Homebrew packages
- Testing: `tests/test_dotfiles.bats` for installation validation

### Installation Flow
1. Requirements validation (git repo, source files exist)
2. Backup creation (timestamped in `~/.dotfiles-backup-YYYYMMDD_HHMMSS`)
3. Symbolic link creation with directory structure setup
4. Post-installation verification
5. Next steps guidance (plugin installation, package updates)

## Development Practices

### Testing Framework
- Uses bats (Bash Automated Testing System) for installation testing
- Test file: `tests/test_dotfiles.bats`
- Tests cover installation validation, symlink verification, and error conditions

### Security Considerations
- Secrets management referenced in DevOps recommendations
- Security validation script: `scripts/security-check.sh`
- Pre-commit hooks for git repositories in `git/templates/hooks/`

### Quality Assurance
- shellcheck for shell script linting
- Comprehensive error handling in enhanced installation script
- Backup strategy to prevent data loss
- Dry-run capability for safe testing

## Editor Configuration

### Neovim (Primary)
- Configuration in `nvim/` directory
- Plugin management using lazy.nvim
- Lua-based configuration in `nvim/lua/`
- CoC settings in `nvim/coc-settings.json`

### Vim (Legacy Support)
- Comprehensive vim configuration maintained in `vim/` directory
- Multiple vimrc files for modular configuration
- Plugin management and color schemes included

## Package Management

### Brewfile
- Manages development tools and applications via Homebrew
- Install packages: `brew bundle --file=Brewfile`
- Comprehensive package list for development environment

## Special Handling

### .vim Directory
- Installation script removes existing `~/.vim` to prevent nested directory issues
- This is documented as "inception kind of thing" prevention

### Logs Directory
- Creates `~/.logs` directory for history and logging
- Used by various configurations for persistent logging

## Troubleshooting

### Common Issues
- Permission problems: Check file ownership and script permissions
- Symlink failures: Verify source files exist and target directories are writable  
- Installation validation: Use `make test` to verify setup

### Validation Commands
- `git config --file gitconfig --list` - Verify git configuration
- `zsh -n zshrc` - Check zsh syntax
- `ls -la ~/.zshrc ~/.gitconfig ~/.config/nvim` - Verify symlinks

## Migration Notes

The repository has transitioned from Vim to Neovim as the primary editor while maintaining backward compatibility. Legacy Vim configurations are preserved in the `vim/` directory.