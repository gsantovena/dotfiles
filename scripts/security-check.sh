#!/bin/bash

# Security Check Script for Dotfiles
# This script performs basic security validation

set -euo pipefail

echo "🔒 Running security checks on dotfiles..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

check_status=0

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check for potential secrets in configuration files
check_secrets() {
    print_status $YELLOW "Checking for potential secrets..."
    
    local secret_patterns=(
        "password"
        "passwd" 
        "secret"
        "api_key"
        "apikey"
        "token"
        "private_key"
        "aws_access"
        "aws_secret"
    )
    
    local files_with_secrets=()
    
    for pattern in "${secret_patterns[@]}"; do
        while IFS= read -r -d '' file; do
            # Skip the security check script itself and documentation
            if [[ "$file" == */security-check.sh ]] || [[ "$file" == */test-install.sh ]] || [[ "$file" == */README.md ]] || [[ "$file" == */DEVOPS_RECOMMENDATIONS.md ]]; then
                continue
            fi
            
            if grep -qi "$pattern" "$file" 2>/dev/null; then
                files_with_secrets+=("$file:$pattern")
            fi
        done < <(find "$DOTFILES_DIR" -type f \( -name "*.sh" -o -name "*.zsh" -o -name "*.bash" -o -name "*rc" -o -name "aliases" -o -name "exports" -o -name "functions" \) -print0)
    done
    
    if [ ${#files_with_secrets[@]} -gt 0 ]; then
        print_status $RED "⚠️  Potential secrets found:"
        for item in "${files_with_secrets[@]}"; do
            echo "  - $item"
        done
        check_status=1
    else
        print_status $GREEN "✅ No obvious secrets found in configuration files"
    fi
}

# Check for hardcoded email addresses
check_emails() {
    print_status $YELLOW "Checking for hardcoded email addresses..."
    
    local email_files=()
    while IFS= read -r -d '' file; do
        if grep -E "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" "$file" > /dev/null 2>&1; then
            email_files+=("$file")
        fi
    done < <(find "$DOTFILES_DIR" -type f \( -name "*.sh" -o -name "*rc" -o -name "gitconfig" -o -name "aliases" -o -name "exports" -o -name "functions" \) -print0)
    
    if [ ${#email_files[@]} -gt 0 ]; then
        print_status $YELLOW "⚠️  Email addresses found in:"
        for file in "${email_files[@]}"; do
            echo "  - $file"
        done
        print_status $YELLOW "Consider using environment variables for email addresses"
    else
        print_status $GREEN "✅ No hardcoded email addresses found"
    fi
}

# Check file permissions
check_permissions() {
    print_status $YELLOW "Checking file permissions..."
    
    local bad_permissions=()
    while IFS= read -r -d '' file; do
        if [ -f "$file" ]; then
            local perms=$(stat -c "%a" "$file" 2>/dev/null || stat -f "%Lp" "$file" 2>/dev/null)
            if [ "${perms: -1}" = "7" ] || [ "${perms: -2:1}" = "7" ]; then
                bad_permissions+=("$file:$perms")
            fi
        fi
    done < <(find "$DOTFILES_DIR" -type f -print0)
    
    if [ ${#bad_permissions[@]} -gt 0 ]; then
        print_status $RED "⚠️  Files with overly permissive permissions:"
        for item in "${bad_permissions[@]}"; do
            echo "  - $item"
        done
        check_status=1
    else
        print_status $GREEN "✅ File permissions look good"
    fi
}

# Check for executable files that shouldn't be
check_executables() {
    print_status $YELLOW "Checking for unexpected executable files..."
    
    local unexpected_executables=()
    while IFS= read -r -d '' file; do
        if [ -x "$file" ] && [[ ! "$file" =~ \.sh$ ]] && [[ ! "$file" =~ install-dotfiles\.sh$ ]]; then
            unexpected_executables+=("$file")
        fi
    done < <(find "$DOTFILES_DIR" -type f \( -name "*rc" -o -name "aliases" -o -name "exports" -o -name "functions" -o -name "gitconfig" \) -print0)
    
    if [ ${#unexpected_executables[@]} -gt 0 ]; then
        print_status $YELLOW "⚠️  Unexpected executable files:"
        for file in "${unexpected_executables[@]}"; do
            echo "  - $file"
        done
        print_status $YELLOW "Consider removing execute permissions if not needed"
    else
        print_status $GREEN "✅ No unexpected executable files found"
    fi
}

# Check .gitignore coverage
check_gitignore() {
    print_status $YELLOW "Checking .gitignore coverage..."
    
    if [ ! -f "$DOTFILES_DIR/.gitignore" ]; then
        print_status $RED "❌ No .gitignore file found"
        check_status=1
        return
    fi
    
    local sensitive_patterns=("secrets" "*.log" "*.key" "*.pem" ".env")
    local missing_patterns=()
    
    for pattern in "${sensitive_patterns[@]}"; do
        if ! grep -q "$pattern" "$DOTFILES_DIR/.gitignore"; then
            missing_patterns+=("$pattern")
        fi
    done
    
    if [ ${#missing_patterns[@]} -gt 0 ]; then
        print_status $YELLOW "⚠️  Consider adding these patterns to .gitignore:"
        for pattern in "${missing_patterns[@]}"; do
            echo "  - $pattern"
        done
    else
        print_status $GREEN "✅ Good .gitignore coverage for sensitive files"
    fi
}

# Main execution
main() {
    cd "$DOTFILES_DIR"
    
    echo "Running security checks in: $DOTFILES_DIR"
    echo "----------------------------------------"
    
    check_secrets
    check_emails  
    check_permissions
    check_executables
    check_gitignore
    
    echo "----------------------------------------"
    
    if [ $check_status -eq 0 ]; then
        print_status $GREEN "🎉 All security checks passed!"
    else
        print_status $RED "⚠️  Some security issues found. Please review the output above."
    fi
    
    exit $check_status
}

main "$@"