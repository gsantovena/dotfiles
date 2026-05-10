# Gerardo Santoveña's dotfiles

My personal dotfiles for a consistent development environment across machines.

## 🚀 Quick Start

```bash
# Clone the repository
git clone git@github.com:gsantovena/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run quality checks
make check

# Install dotfiles
make install
```

## 📋 Features

- **Shell Configuration**: Zsh with zinit-managed plugins, Oh My Posh prompt, custom aliases, and functions
- **Editor Setup**: Neovim-only configuration with lazy.nvim plugin management
- **Terminal Multiplexer**: Tmux configuration with TPM plugin management
- **Git Configuration**: Custom aliases and templates for efficient workflows
- **Package Management**: Comprehensive Brewfile for development tools
- **Security**: Proper secrets management and validation
- **Testing**: Automated installation validation and security checks

## 🔧 Installation Options

### Using Make (Recommended)
```bash
make install-dry       # Preview symlink and backup changes
make install           # Full installation with backup and validation
make quick-install     # Run checks, then install
make install-no-backup # Install only if no existing targets need backup
```

### Direct Script Usage
```bash
# Dry run to see what will be changed
./scripts/install-enhanced.sh --dry-run

# Install with backup and validation
./scripts/install-enhanced.sh --backup --verbose

# Force installation (skip validation)
./scripts/install-enhanced.sh --force
```

## 📁 Structure

```
dotfiles/
├── .github/workflows/    # CI/CD automation
├── scripts/             # Installation, test, and validation scripts
├── tests/              # Automated tests
├── aliases             # Shell aliases
├── bash_profile        # Bash configuration
├── exports             # Environment variables
├── functions           # Shell functions
├── git/                # Git templates and hooks
├── gitconfig           # Git configuration
├── nvim/               # Neovim configuration
├── ohmyposh/           # Oh My Posh prompt themes
├── tmux/               # Tmux configuration
├── zsh/                # Modular Zsh configuration
├── zshrc               # Zsh module loader
├── Brewfile            # Package management
└── Makefile            # Build automation
```

## 🔒 Security Features

### Secrets Management
- Environment variables for sensitive data
- Encrypted storage support (GPG/age)
- Pre-commit secret detection
- Comprehensive .gitignore patterns

### Automated Security Checks
```bash
make security          # Run security validation
./scripts/security-check.sh
```

### Best Practices
- No hardcoded credentials in version control
- Proper file permissions validation
- Email address externalization
- Secure backup procedures

## 🧪 Testing & Validation

### Automated Testing
```bash
make test             # Run installation tests
make lint             # Shell script linting
make check            # Complete quality validation
```

### Manual Testing
```bash
# Test installation in safe environment
./scripts/test-install.sh

# Validate configurations
git config --file gitconfig --list
zsh -n zshrc
zsh -n zsh/*.zsh
```

## 📦 Requirements

### Essential
- **Git**: Version control
- **Zsh**: Modern shell
- **zinit**: Zsh plugin manager (bootstrapped automatically by `zsh/00-zinit.zsh`)
- **Oh My Posh**: Prompt engine using configs from `ohmyposh/`
- **Homebrew**: Package management (macOS)

### Optional
- **Neovim**: Modern text editor
- **shellcheck**: Script linting
- **bats**: Testing framework

### Installation Commands
```bash
# macOS
brew install git zsh neovim shellcheck oh-my-posh

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install git zsh neovim shellcheck
# Install Oh My Posh with your platform package manager or from https://ohmyposh.dev

# Install all Homebrew-managed tools on macOS
brew bundle --file=Brewfile
```

## 🔄 Neovim-only editor setup

This repository now uses **Neovim as the only tracked editor configuration**.
The active runtime lives under `nvim/`, with:

- `nvim/init.vim` as the thin entrypoint
- `nvim/lua/config/*` for general editor behavior
- `nvim/lua/plugins/*` for grouped lazy.nvim plugin specs
- `nvim/coc-settings.json` for CoC settings

Supporting Neovim docs:

- `nvim/README.md` — structure and ownership
- `nvim/PLUGIN_AUDIT.md` — current plugin inventory
- `nvim/PLUGIN_REEVALUATION.md` — keep/remove/replace decisions

### Setup Neovim Plugins
```bash
# Plugins are managed by lazy.nvim and install automatically
# Open Neovim to trigger plugin installation
nvim

# Or manually trigger lazy.nvim
nvim -c "Lazy install" -c "qa"
```

## 🧩 Tmux plugin setup

The installer bootstraps [TPM](https://github.com/tmux-plugins/tpm) into
`~/.config/tmux/plugins/tpm`. Other tmux plugins are declared in `tmux/tmux.conf`
and installed by TPM.

```bash
# After installation, reload tmux config
tmux source-file ~/.config/tmux/tmux.conf

# Then press prefix + I inside tmux to install declared plugins
```

### Key improvements
- Better plugin support and performance
- Asynchronous processing
- Modern architecture
- Lua configuration support
- No split ownership between `nvim/` and legacy Vim files

## 🏗️ CI/CD & Automation

### GitHub Actions
- Automated testing on multiple OS platforms
- Shell script linting with shellcheck
- Security scanning and validation
- Configuration syntax checking

### Quality Gates
- Installation validation
- Security compliance
- Cross-platform compatibility
- Performance checks

## 📚 Customization

### Personal vs Work Configuration
```bash
# Set environment-specific variables
export WORK_ENVIRONMENT="true"  # in secrets file

# Use in configurations
if [[ "$WORK_ENVIRONMENT" == "true" ]]; then
    # Work-specific settings
fi
```

### Adding New Configurations
1. Add the file to the repository
2. Update `HOME_FILES` or `CONFIG_FILES` in `scripts/install-enhanced.sh`
3. Test with `make test`
4. Document any dependencies

## 🔄 Maintenance

### Regular Updates
```bash
# Update packages
brew bundle --file=Brewfile

# Update plugins
nvim -c "Lazy update" -c "qa"

# Update tmux plugins
# Press prefix + U inside tmux

# Run health checks
make check
```

### Backup & Recovery
```bash
# Create backup before changes
./scripts/install-enhanced.sh --backup

# Restore from backup
cp -r ~/.dotfiles-backup-YYYYMMDD_HHMMSS/.* ~/
```

## 🚨 Troubleshooting

### Common Issues

**Installation fails with permission errors**
```bash
# Fix ownership
sudo chown -R $USER:$USER ~/.dotfiles

# Check permissions
./scripts/security-check.sh
```

**Symlinks not working**
```bash
# Verify installation
./scripts/test-install.sh

# Manual verification
ls -la ~/.zshrc ~/.gitconfig ~/.config/nvim ~/.config/ohmyposh
```

**Neovim statusline icons look wrong**
```bash
# Install a Nerd Font if needed
brew install --cask font-hack-nerd-font
```

Then select **Hack Nerd Font** in your terminal profile. In iTerm2:
Settings → Profiles → Text → Font.

**Zsh prompt or plugins not loading**
```bash
# Ensure Oh My Posh is installed and the prompt config is linked
brew install oh-my-posh
ls -la ~/.config/ohmyposh/zen.toml

# Re-run the installer if the symlink is missing
make install

# Restart shell
exec zsh
```

The zinit bootstrap in `zsh/00-zinit.zsh` installs zinit into
`${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git` on first shell startup.

### Getting Help
- Check GitHub Issues for known problems
- Run `make check` for comprehensive validation
- Review logs in `~/.logs/` directory

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run quality checks: `make check`
5. Submit a pull request

### Development Workflow
```bash
# Set up development environment
git clone your-fork
cd dotfiles

# Make changes
vim some-config-file

# Test changes
make test

# Run security checks
make security

# Commit and push
git add .
git commit -m "feat: add new configuration"
git push origin feature-branch
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- zinit, Oh My Posh, and Oh My Zsh communities for shell enhancements
- Vim/Neovim community for editor excellence
- Homebrew maintainers for package management
- Open source contributors who make development better

---

*Last updated: $(date)*
*For DevOps recommendations and improvements, see [DEVOPS_RECOMMENDATIONS.md](DEVOPS_RECOMMENDATIONS.md)*
