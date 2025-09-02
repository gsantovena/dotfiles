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

- **Shell Configuration**: Zsh with oh-my-zsh, custom aliases and functions
- **Editor Setup**: Neovim configuration with plugin management
- **Git Configuration**: Custom aliases and templates for efficient workflows
- **Package Management**: Comprehensive Brewfile for development tools
- **Security**: Proper secrets management and validation
- **Testing**: Automated installation validation and security checks

## 🔧 Installation Options

### Standard Installation
```bash
./install-dotfiles.sh
```

### Enhanced Installation (Recommended)
```bash
# Dry run to see what will be changed
./scripts/install-enhanced.sh --dry-run

# Install with backup and validation
./scripts/install-enhanced.sh --backup --verbose

# Force installation (skip validation)
./scripts/install-enhanced.sh --force
```

### Using Make (Recommended)
```bash
make install-dry    # Dry run
make install        # Full installation
make check          # Run all quality checks
make quick-install  # Run checks then install
```

## 📁 Structure

```
dotfiles/
├── .github/workflows/    # CI/CD automation
├── scripts/             # Installation and validation scripts
├── tests/              # Automated tests
├── aliases             # Shell aliases
├── bash_profile        # Bash configuration
├── exports             # Environment variables
├── functions           # Shell functions
├── git/                # Git templates and hooks
├── gitconfig           # Git configuration
├── nvim/               # Neovim configuration
├── vim/                # Legacy Vim configuration
├── zshrc               # Zsh configuration
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
```

## 📦 Requirements

### Essential
- **Git**: Version control
- **Zsh**: Modern shell (oh-my-zsh recommended)
- **Homebrew**: Package management (macOS)

### Optional
- **Neovim**: Modern text editor
- **shellcheck**: Script linting
- **bats**: Testing framework

### Installation Commands
```bash
# macOS
brew install git zsh neovim shellcheck

# Ubuntu/Debian
sudo apt-get update
sudo apt-get install git zsh neovim shellcheck

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## 🔄 Migration from Vim to Neovim

This repository has transitioned from Vim to Neovim for enhanced features:

### Setup Neovim Plugins
```bash
# Plugins are managed by lazy.nvim and install automatically
# Open Neovim to trigger plugin installation
nvim

# Or manually trigger lazy.nvim
nvim -c "Lazy install" -c "qa"
```

### Key Improvements
- Better plugin support and performance
- Asynchronous processing
- Modern architecture
- Lua configuration support

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
2. Update `HOME_FILES` or `CONFIG_FILES` in install scripts
3. Test with `make test`
4. Document any dependencies

## 🔄 Maintenance

### Regular Updates
```bash
# Update packages
brew bundle --file=Brewfile

# Update plugins
nvim -c "Lazy update" -c "qa"

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
ls -la ~/.zshrc ~/.gitconfig ~/.config/nvim
```

**Oh-my-zsh not loading**
```bash
# Install oh-my-zsh first
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Restart shell
exec zsh
```

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

- Oh-my-zsh community for shell enhancements
- Vim/Neovim community for editor excellence
- Homebrew maintainers for package management
- Open source contributors who make development better

---

*Last updated: $(date)*
*For DevOps recommendations and improvements, see [DEVOPS_RECOMMENDATIONS.md](DEVOPS_RECOMMENDATIONS.md)*

