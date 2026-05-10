#!/bin/bash

# Test Installation Script for Dotfiles
# This script tests the installation process in a safe environment

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
INSTALL_SCRIPT="$DOTFILES_DIR/scripts/install-enhanced.sh"

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Create a temporary test environment
setup_test_env() {
    print_status "$BLUE" "Setting up test environment..."
    
    export TEST_HOME="/tmp/dotfiles-test-$$"
    export TEST_CONFIG_DIR="$TEST_HOME/.config"
    
    # Clean up any existing test directory
    rm -rf "$TEST_HOME"
    
    # Create test directories
    mkdir -p "$TEST_HOME"
    mkdir -p "$TEST_CONFIG_DIR"
    
    # Create some fake existing files to test backup behavior
    echo "# Original bash_profile" > "$TEST_HOME/.bash_profile"
    echo "# Original zshrc" > "$TEST_HOME/.zshrc"
    mkdir -p "$TEST_HOME/.git"
    echo "# Original git metadata" > "$TEST_HOME/.git/config"
    mkdir -p "$TEST_HOME/.config/nvim"
    echo '" Original Neovim config' > "$TEST_HOME/.config/nvim/init.vim"
    mkdir -p "$TEST_HOME/.config/tmux"
    echo "# Original tmux config" > "$TEST_HOME/.config/tmux/tmux.conf"
    print_status "$GREEN" "Test environment created at: $TEST_HOME"
}

# Test the installation script syntax
test_script_syntax() {
    print_status "$BLUE" "Testing installation script syntax..."
    
    if bash -n "$INSTALL_SCRIPT" "$DOTFILES_DIR/scripts/security-check.sh" "$DOTFILES_DIR/scripts/test-install.sh"; then
        print_status "$GREEN" "✅ Script syntax is valid"
    else
        print_status "$RED" "❌ Script syntax errors found"
        return 1
    fi
}

# Test dry-run installation
test_dry_run() {
    print_status "$BLUE" "Testing dry-run installation..."
    
    if env HOME="$TEST_HOME" DOTFILES_SKIP_TPM_BOOTSTRAP=true bash "$INSTALL_SCRIPT" --dry-run --verbose; then
        print_status "$GREEN" "✅ Dry-run installation completed successfully"
    else
        print_status "$RED" "❌ Dry-run installation failed"
        return 1
    fi
}

# Test actual installation in test environment
test_actual_install() {
    print_status "$BLUE" "Testing actual installation in test environment..."
    
    # Save original HOME
    local original_home="$HOME"
    
    # Temporarily change HOME for the test
    export HOME="$TEST_HOME"
    
    # Create logs directory as expected by the install script
    mkdir -p "$TEST_HOME/.logs"
    
    # Run the actual install script
    if DOTFILES_SKIP_TPM_BOOTSTRAP=true bash "$INSTALL_SCRIPT" --backup --verbose; then
        print_status "$GREEN" "✅ Installation completed successfully"
        
        # Verify some key symlinks were created
        local verification_failed=false
        
        if [ -L "$TEST_HOME/.zshrc" ]; then
            print_status "$GREEN" "✅ .zshrc symlink created"
        else
            print_status "$RED" "❌ .zshrc symlink missing"
            verification_failed=true
        fi
        
        if [ -L "$TEST_HOME/.gitconfig" ]; then
            print_status "$GREEN" "✅ .gitconfig symlink created"
        else
            print_status "$RED" "❌ .gitconfig symlink missing"
            verification_failed=true
        fi

        if [ -L "$TEST_HOME/.git" ]; then
            print_status "$GREEN" "✅ .git symlink created"
        else
            print_status "$RED" "❌ .git symlink missing"
            verification_failed=true
        fi

        if [ -L "$TEST_HOME/.git/git" ]; then
            print_status "$RED" "❌ Nested .git/git symlink should not be created"
            verification_failed=true
        fi
        
        if [ -L "$TEST_HOME/.config/nvim" ]; then
            print_status "$GREEN" "✅ .config/nvim symlink created"
        else
            print_status "$RED" "❌ .config/nvim symlink missing"
            verification_failed=true
        fi

        if [ -L "$TEST_HOME/.config/nvim/nvim" ]; then
            print_status "$RED" "❌ Nested .config/nvim/nvim symlink should not be created"
            verification_failed=true
        fi

        if [ -L "$TEST_HOME/.config/ghostty" ]; then
            print_status "$GREEN" "✅ .config/ghostty symlink created"
        else
            print_status "$RED" "❌ .config/ghostty symlink missing"
            verification_failed=true
        fi

        if [ -L "$TEST_HOME/.config/tmux" ]; then
            print_status "$GREEN" "✅ .config/tmux symlink created"
        else
            print_status "$RED" "❌ .config/tmux symlink missing"
            verification_failed=true
        fi

        if [ -L "$TEST_HOME/.config/tmux/tmux" ]; then
            print_status "$RED" "❌ Nested .config/tmux/tmux symlink should not be created"
            verification_failed=true
        fi

        local backup_dir
        backup_dir=$(find "$TEST_HOME" -maxdepth 1 -type d -name ".dotfiles-backup-*" | head -n 1)
        if [ -n "$backup_dir" ] && [ -f "$backup_dir/git/config" ] && [ -f "$backup_dir/.config/nvim/init.vim" ] && [ -f "$backup_dir/.config/tmux/tmux.conf" ]; then
            print_status "$GREEN" "✅ Existing directories moved to backup before linking"
        else
            print_status "$RED" "❌ Existing directory backup missing"
            verification_failed=true
        fi
        
        if [ "$verification_failed" = true ]; then
            print_status "$RED" "❌ Some symlinks were not created correctly"
            export HOME="$original_home"
            return 1
        fi
        
    else
        print_status "$RED" "❌ Installation failed"
        export HOME="$original_home"
        return 1
    fi
    
    # Restore original HOME
    export HOME="$original_home"
}

# Test configuration file syntax
test_config_syntax() {
    print_status "$BLUE" "Testing configuration file syntax..."
    
    local syntax_errors=false
    
    # Test shell configurations
    if command -v zsh >/dev/null 2>&1; then
        if zsh -n "$DOTFILES_DIR/zshrc" 2>/dev/null; then
            print_status "$GREEN" "✅ zshrc syntax is valid"
        else
            print_status "$YELLOW" "⚠️  zshrc may have syntax issues (some oh-my-zsh features might not be available in test)"
        fi
    else
        print_status "$YELLOW" "⚠️  zsh not available for syntax testing"
    fi
    
    if bash -n "$DOTFILES_DIR/bash_profile" 2>/dev/null; then
        print_status "$GREEN" "✅ bash_profile syntax is valid"
    else
        print_status "$RED" "❌ bash_profile has syntax errors"
        syntax_errors=true
    fi
    
    # Test git configuration
    if git config --file "$DOTFILES_DIR/gitconfig" --list >/dev/null 2>&1; then
        print_status "$GREEN" "✅ gitconfig is valid"
    else
        print_status "$RED" "❌ gitconfig has errors"
        syntax_errors=true
    fi
    
    if [ "$syntax_errors" = true ]; then
        return 1
    fi
}

# Cleanup test environment
# shellcheck disable=SC2329 # Invoked by the EXIT trap in main.
cleanup() {
    print_status "$BLUE" "Cleaning up test environment..."
    if [ -n "${TEST_HOME:-}" ] && [ -d "$TEST_HOME" ]; then
        rm -rf "$TEST_HOME"
        print_status "$GREEN" "Test environment cleaned up"
    fi
}

# Main execution
main() {
    local exit_code=0
    
    print_status "$BLUE" "🧪 Starting dotfiles installation tests..."
    echo "========================================"
    
    # Set up cleanup trap
    trap cleanup EXIT
    
    setup_test_env || exit_code=1
    
    test_script_syntax || exit_code=1
    
    test_config_syntax || exit_code=1
    
    test_dry_run || exit_code=1
    
    test_actual_install || exit_code=1
    
    echo "========================================"
    
    if [ $exit_code -eq 0 ]; then
        print_status "$GREEN" "🎉 All installation tests passed!"
    else
        print_status "$RED" "❌ Some tests failed. Please review the output above."
    fi
    
    exit $exit_code
}

main "$@"
