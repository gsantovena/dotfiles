#!/usr/bin/env bats

# Bats tests for dotfiles installation
# Run with: bats tests/test_dotfiles.bats

setup() {
    # Create a temporary directory for tests
    export TEST_TMPDIR="/tmp/dotfiles-bats-$$"
    mkdir -p "$TEST_TMPDIR"
    
    # Set up test environment
    export DOTFILES_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

teardown() {
    # Clean up test directory
    if [ -d "$TEST_TMPDIR" ]; then
        rm -rf "$TEST_TMPDIR"
    fi
}

@test "install script syntax is valid" {
    run bash -n "$DOTFILES_DIR/install-dotfiles.sh"
    [ "$status" -eq 0 ]
}

@test "enhanced install script syntax is valid" {
    run bash -n "$DOTFILES_DIR/scripts/install-enhanced.sh"
    [ "$status" -eq 0 ]
}

@test "security check script runs without errors" {
    run "$DOTFILES_DIR/scripts/security-check.sh"
    [ "$status" -eq 0 ]
}

@test "test install script runs without errors" {
    run "$DOTFILES_DIR/scripts/test-install.sh"
    [ "$status" -eq 0 ]
}

@test "required dotfiles exist" {
    local files=("zshrc" "bash_profile" "gitconfig" "aliases" "exports" "functions")
    
    for file in "${files[@]}"; do
        [ -f "$DOTFILES_DIR/$file" ]
    done
}

@test "git configuration is valid" {
    run git config --file "$DOTFILES_DIR/gitconfig" --list
    [ "$status" -eq 0 ]
}

@test "zsh configuration syntax" {
    # Skip if zsh is not available
    if ! command -v zsh >/dev/null 2>&1; then
        skip "zsh not available"
    fi
    
    # Test basic syntax (may not catch all oh-my-zsh issues)
    run zsh -n "$DOTFILES_DIR/zshrc"
    [ "$status" -eq 0 ]
}

@test "bash profile syntax" {
    run bash -n "$DOTFILES_DIR/bash_profile"
    [ "$status" -eq 0 ]
}