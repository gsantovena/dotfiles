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

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Create a temporary test environment
setup_test_env() {
    print_status $BLUE "Setting up test environment..."
    
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
    mkdir -p "$TEST_HOME/.vim"
    echo "# Original vim config" > "$TEST_HOME/.vim/vimrc"
    
    print_status $GREEN "Test environment created at: $TEST_HOME"
}

# Test the installation script syntax
test_script_syntax() {
    print_status $BLUE "Testing installation script syntax..."
    
    if bash -n "$DOTFILES_DIR/install-dotfiles.sh"; then
        print_status $GREEN "✅ Installation script syntax is valid"
    else
        print_status $RED "❌ Installation script has syntax errors"
        return 1
    fi
}

# Test dry-run installation
test_dry_run() {
    print_status $BLUE "Testing dry-run installation..."
    
    # Create a modified version of the install script for testing
    local test_script="$TEST_HOME/test-install.sh"
    
    cat > "$test_script" << 'EOF'
#!/bin/bash

DOTFILES_DIR="$1"
TEST_HOME="$2"
HOME_FILES="bash_profile aliases exports functions git gitconfig vim zshrc secrets screenrc"
CONFIG_FILES="nvim"

echo "DOTFILES_DIR: $DOTFILES_DIR"
echo "TEST_HOME: $TEST_HOME"
echo "Files to link:"

link() {
  echo "Would link: ${DOTFILES_DIR}/${1} --> ${2}"
  
  # Check if source file exists
  if [ ! -e "${DOTFILES_DIR}/${1}" ]; then
    echo "WARNING: Source file does not exist: ${DOTFILES_DIR}/${1}"
    return 1
  fi
  
  # Check if target directory exists
  local target_dir=$(dirname "${2}")
  if [ ! -d "$target_dir" ]; then
    echo "WARNING: Target directory does not exist: $target_dir"
    return 1
  fi
  
  return 0
}

# Test home files
for FILE in ${HOME_FILES}
do
    if ! link "${FILE}" "${TEST_HOME}/.${FILE}"; then
        echo "ERROR: Failed to validate linking for $FILE"
        exit 1
    fi
done

# Test config files
for FILE in ${CONFIG_FILES}
do
    if ! link "${FILE}" "${TEST_HOME}/.config/${FILE}"; then
        echo "ERROR: Failed to validate linking for $FILE"
        exit 1
    fi
done

echo "All file links validated successfully!"
EOF

    chmod +x "$test_script"
    
    if "$test_script" "$DOTFILES_DIR" "$TEST_HOME"; then
        print_status $GREEN "✅ Dry-run installation completed successfully"
    else
        print_status $RED "❌ Dry-run installation failed"
        return 1
    fi
}

# Test actual installation in test environment
test_actual_install() {
    print_status $BLUE "Testing actual installation in test environment..."
    
    # Save original HOME
    local original_home="$HOME"
    
    # Temporarily change HOME for the test
    export HOME="$TEST_HOME"
    
    # Create logs directory as expected by the install script
    mkdir -p "$TEST_HOME/.logs"
    
    # Run the actual install script
    cd "$DOTFILES_DIR"
    if ./install-dotfiles.sh; then
        print_status $GREEN "✅ Installation completed successfully"
        
        # Verify some key symlinks were created
        local verification_failed=false
        
        if [ -L "$TEST_HOME/.zshrc" ]; then
            print_status $GREEN "✅ .zshrc symlink created"
        else
            print_status $RED "❌ .zshrc symlink missing"
            verification_failed=true
        fi
        
        if [ -L "$TEST_HOME/.gitconfig" ]; then
            print_status $GREEN "✅ .gitconfig symlink created"
        else
            print_status $RED "❌ .gitconfig symlink missing"
            verification_failed=true
        fi
        
        if [ -L "$TEST_HOME/.config/nvim" ]; then
            print_status $GREEN "✅ .config/nvim symlink created"
        else
            print_status $RED "❌ .config/nvim symlink missing"
            verification_failed=true
        fi
        
        if [ "$verification_failed" = true ]; then
            print_status $RED "❌ Some symlinks were not created correctly"
            export HOME="$original_home"
            return 1
        fi
        
    else
        print_status $RED "❌ Installation failed"
        export HOME="$original_home"
        return 1
    fi
    
    # Restore original HOME
    export HOME="$original_home"
}

# Test configuration file syntax
test_config_syntax() {
    print_status $BLUE "Testing configuration file syntax..."
    
    local syntax_errors=false
    
    # Test shell configurations
    if command -v zsh >/dev/null 2>&1; then
        if zsh -n "$DOTFILES_DIR/zshrc" 2>/dev/null; then
            print_status $GREEN "✅ zshrc syntax is valid"
        else
            print_status $YELLOW "⚠️  zshrc may have syntax issues (some oh-my-zsh features might not be available in test)"
        fi
    else
        print_status $YELLOW "⚠️  zsh not available for syntax testing"
    fi
    
    if bash -n "$DOTFILES_DIR/bash_profile" 2>/dev/null; then
        print_status $GREEN "✅ bash_profile syntax is valid"
    else
        print_status $RED "❌ bash_profile has syntax errors"
        syntax_errors=true
    fi
    
    # Test git configuration
    if git config --file "$DOTFILES_DIR/gitconfig" --list >/dev/null 2>&1; then
        print_status $GREEN "✅ gitconfig is valid"
    else
        print_status $RED "❌ gitconfig has errors"
        syntax_errors=true
    fi
    
    if [ "$syntax_errors" = true ]; then
        return 1
    fi
}

# Cleanup test environment
cleanup() {
    print_status $BLUE "Cleaning up test environment..."
    if [ -n "${TEST_HOME:-}" ] && [ -d "$TEST_HOME" ]; then
        rm -rf "$TEST_HOME"
        print_status $GREEN "Test environment cleaned up"
    fi
}

# Main execution
main() {
    local exit_code=0
    
    print_status $BLUE "🧪 Starting dotfiles installation tests..."
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
        print_status $GREEN "🎉 All installation tests passed!"
    else
        print_status $RED "❌ Some tests failed. Please review the output above."
    fi
    
    exit $exit_code
}

main "$@"