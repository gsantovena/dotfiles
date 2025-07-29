#!/bin/bash

# Enhanced Installation Script for Dotfiles
# Includes validation, backup, and error handling

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
HISTORY_LOGS=${HOME}/.logs
DOTFILES_DIR=$(git rev-parse --show-toplevel)
HOME_FILES="bash_profile aliases exports functions git gitconfig vim zshrc screenrc"
CONFIG_FILES="nvim"
BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to print usage
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -d, --dry-run  Show what would be done without making changes"
    echo "  -b, --backup   Create backup before installation (default: true)"
    echo "  -f, --force    Force installation even if validation fails"
    echo "  -v, --verbose  Verbose output"
    echo ""
}

# Parse command line arguments
DRY_RUN=false
CREATE_BACKUP=true
FORCE_INSTALL=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -b|--backup)
            CREATE_BACKUP=true
            shift
            ;;
        --no-backup)
            CREATE_BACKUP=false
            shift
            ;;
        -f|--force)
            FORCE_INSTALL=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Validation functions
check_requirements() {
    print_status $BLUE "Checking requirements..."
    
    local missing_requirements=()
    
    # Check if we're in a git repository
    if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
        missing_requirements+=("Must be run from within the dotfiles git repository")
    fi
    
    # Check if required directories exist
    if [ ! -d "$DOTFILES_DIR" ]; then
        missing_requirements+=("Dotfiles directory not found: $DOTFILES_DIR")
    fi
    
    # Check if all source files exist
    for file in $HOME_FILES; do
        if [ ! -e "$DOTFILES_DIR/$file" ]; then
            missing_requirements+=("Missing source file: $DOTFILES_DIR/$file")
        fi
    done
    
    for file in $CONFIG_FILES; do
        if [ ! -e "$DOTFILES_DIR/$file" ]; then
            missing_requirements+=("Missing source file: $DOTFILES_DIR/$file")
        fi
    done
    
    if [ ${#missing_requirements[@]} -gt 0 ]; then
        print_status $RED "❌ Requirements check failed:"
        for req in "${missing_requirements[@]}"; do
            echo "  - $req"
        done
        
        if [ "$FORCE_INSTALL" = false ]; then
            exit 1
        else
            print_status $YELLOW "⚠️  Continuing with --force flag despite missing requirements"
        fi
    else
        print_status $GREEN "✅ All requirements satisfied"
    fi
}

# Backup existing files
create_backup() {
    if [ "$CREATE_BACKUP" = false ]; then
        return 0
    fi
    
    print_status $BLUE "Creating backup of existing files..."
    
    local files_backed_up=()
    
    # Create backup directory
    mkdir -p "$BACKUP_DIR"
    
    # Backup home files
    for file in $HOME_FILES; do
        local target="$HOME/.$file"
        if [ -e "$target" ]; then
            if [ "$DRY_RUN" = false ]; then
                cp -r "$target" "$BACKUP_DIR/$file" 2>/dev/null || true
            fi
            files_backed_up+=(".$file")
        fi
    done
    
    # Backup config files
    for file in $CONFIG_FILES; do
        local target="$HOME/.config/$file"
        if [ -e "$target" ]; then
            if [ "$DRY_RUN" = false ]; then
                mkdir -p "$BACKUP_DIR/.config"
                cp -r "$target" "$BACKUP_DIR/.config/$file" 2>/dev/null || true
            fi
            files_backed_up+=(".config/$file")
        fi
    done
    
    if [ ${#files_backed_up[@]} -gt 0 ]; then
        print_status $GREEN "✅ Backed up ${#files_backed_up[@]} files to: $BACKUP_DIR"
        if [ "$VERBOSE" = true ]; then
            for file in "${files_backed_up[@]}"; do
                echo "  - $file"
            done
        fi
    else
        print_status $YELLOW "No existing files to backup"
        if [ "$DRY_RUN" = false ]; then
            rmdir "$BACKUP_DIR" 2>/dev/null || true
        fi
    fi
}

# Enhanced link function with validation
link() {
    local source="$DOTFILES_DIR/$1"
    local target="$2"
    local target_dir=$(dirname "$target")
    
    # Validate source exists
    if [ ! -e "$source" ]; then
        print_status $RED "❌ Source file does not exist: $source"
        return 1
    fi
    
    # Create target directory if needed
    if [ ! -d "$target_dir" ]; then
        if [ "$DRY_RUN" = false ]; then
            mkdir -p "$target_dir"
        fi
        if [ "$VERBOSE" = true ]; then
            print_status $BLUE "Created directory: $target_dir"
        fi
    fi
    
    # Show what we're doing
    if [ "$DRY_RUN" = true ]; then
        echo "Would link: $source --> $target"
    else
        if [ "$VERBOSE" = true ]; then
            echo "Linking: $source --> $target"
        else
            echo "$source --> $target"
        fi
        ln -sf "$source" "$target"
    fi
    
    return 0
}

# Install dotfiles
install_dotfiles() {
    print_status $BLUE "Installing dotfiles..."
    
    # Create logs directory
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$HISTORY_LOGS"
    fi
    
    # Handle special case for .vim directory
    if [ -e "${HOME}/.vim" ] && [ "$DRY_RUN" = false ]; then
        if [ "$VERBOSE" = true ]; then
            print_status $YELLOW "Removing existing .vim directory to prevent inception"
        fi
        rm -rf "${HOME}/.vim"
    fi
    
    local link_errors=0
    
    # Link home files
    for file in $HOME_FILES; do
        if ! link "$file" "$HOME/.$file"; then
            ((link_errors++))
        fi
    done
    
    # Link config files
    for file in $CONFIG_FILES; do
        if ! link "$file" "$HOME/.config/$file"; then
            ((link_errors++))
        fi
    done
    
    if [ $link_errors -gt 0 ]; then
        print_status $RED "❌ $link_errors linking errors occurred"
        return 1
    else
        print_status $GREEN "✅ All files linked successfully"
    fi
}

# Verify installation
verify_installation() {
    if [ "$DRY_RUN" = true ]; then
        return 0
    fi
    
    print_status $BLUE "Verifying installation..."
    
    local verification_errors=0
    
    # Verify home files
    for file in $HOME_FILES; do
        local target="$HOME/.$file"
        if [ -L "$target" ]; then
            local link_target=$(readlink "$target")
            if [ "$link_target" = "$DOTFILES_DIR/$file" ]; then
                if [ "$VERBOSE" = true ]; then
                    print_status $GREEN "✅ $target correctly linked"
                fi
            else
                print_status $RED "❌ $target points to wrong location: $link_target"
                ((verification_errors++))
            fi
        else
            print_status $RED "❌ $target is not a symlink"
            ((verification_errors++))
        fi
    done
    
    # Verify config files
    for file in $CONFIG_FILES; do
        local target="$HOME/.config/$file"
        if [ -L "$target" ]; then
            local link_target=$(readlink "$target")
            if [ "$link_target" = "$DOTFILES_DIR/$file" ]; then
                if [ "$VERBOSE" = true ]; then
                    print_status $GREEN "✅ $target correctly linked"
                fi
            else
                print_status $RED "❌ $target points to wrong location: $link_target"
                ((verification_errors++))
            fi
        else
            print_status $RED "❌ $target is not a symlink"
            ((verification_errors++))
        fi
    done
    
    if [ $verification_errors -gt 0 ]; then
        print_status $RED "❌ $verification_errors verification errors found"
        return 1
    else
        print_status $GREEN "✅ Installation verified successfully"
    fi
}

# Print next steps
print_next_steps() {
    print_status $BLUE "Next steps:"
    echo ""
    echo "1. Install Neovim plugins:"
    echo "   curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \\"
    echo "     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    echo "   nvim +PlugInstall +qall"
    echo ""
    echo "2. Install Homebrew packages:"
    echo "   brew bundle --file=$DOTFILES_DIR/Brewfile"
    echo ""
    echo "3. Restart your shell or run:"
    echo "   source ~/.zshrc"
    echo ""
    if [ "$CREATE_BACKUP" = true ] && [ -d "$BACKUP_DIR" ]; then
        echo "4. Your original files are backed up in:"
        echo "   $BACKUP_DIR"
        echo ""
    fi
}

# Main execution
main() {
    print_status $BLUE "🏠 Enhanced Dotfiles Installation"
    echo "================================="
    
    if [ "$DRY_RUN" = true ]; then
        print_status $YELLOW "DRY RUN MODE - No changes will be made"
    fi
    
    check_requirements
    create_backup
    install_dotfiles
    verify_installation
    
    echo "================================="
    
    if [ "$DRY_RUN" = true ]; then
        print_status $BLUE "Dry run completed successfully!"
        print_status $YELLOW "Run without --dry-run to perform actual installation"
    else
        print_status $GREEN "🎉 Installation completed successfully!"
        print_next_steps
    fi
}

main "$@"