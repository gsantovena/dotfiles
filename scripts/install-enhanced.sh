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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
HOME_FILES="bash_profile aliases exports functions git gitconfig zshrc screenrc"
HOME_SOURCE_DIR="home"
CONFIG_FILES="nvim ghostty tmux ohmyposh"
CONFIG_SOURCE_DIR="config"
BACKUP_DIR="${HOME}/.dotfiles-backup-$(date +%Y%m%d_%H%M%S)"
TPM_REPO_URL="${TPM_REPO_URL:-https://github.com/tmux-plugins/tpm.git}"
TPM_INSTALL_DIR="${TPM_INSTALL_DIR:-$HOME/.config/tmux/plugins/tpm}"

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
    echo "  -h, --help       Show this help message"
    echo "  -d, --dry-run    Show what would be done without making changes"
    echo "  -b, --backup     Create backup before installation (default: true)"
    echo "      --no-backup  Skip backup creation"
    echo "  -f, --force      Force installation even if validation fails"
    echo "  -v, --verbose    Verbose output"
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
    print_status "$BLUE" "Checking requirements..."
    
    local missing_requirements=()
    
    # Check if the script is installed inside a git repository
    if ! git -C "$DOTFILES_DIR" rev-parse --show-toplevel >/dev/null 2>&1; then
        missing_requirements+=("Dotfiles directory is not a git repository: $DOTFILES_DIR")
    fi
    
    # Check if required directories exist
    if [ ! -d "$DOTFILES_DIR" ]; then
        missing_requirements+=("Dotfiles directory not found: $DOTFILES_DIR")
    fi
    
    # Check if all source files exist
    for file in $HOME_FILES; do
        if [ ! -e "$DOTFILES_DIR/$HOME_SOURCE_DIR/$file" ]; then
            missing_requirements+=("Missing source file: $DOTFILES_DIR/$HOME_SOURCE_DIR/$file")
        fi
    done
    
    for file in $CONFIG_FILES; do
        if [ ! -e "$DOTFILES_DIR/$CONFIG_SOURCE_DIR/$file" ]; then
            missing_requirements+=("Missing source file: $DOTFILES_DIR/$CONFIG_SOURCE_DIR/$file")
        fi
    done
    
    if [ ${#missing_requirements[@]} -gt 0 ]; then
        print_status "$RED" "❌ Requirements check failed:"
        for req in "${missing_requirements[@]}"; do
            echo "  - $req"
        done
        
        if [ "$FORCE_INSTALL" = false ]; then
            exit 1
        else
            print_status "$YELLOW" "⚠️  Continuing with --force flag despite missing requirements"
        fi
    else
        print_status "$GREEN" "✅ All requirements satisfied"
    fi
}

# Backup existing files
create_backup() {
    if [ "$CREATE_BACKUP" = false ]; then
        return 0
    fi
    
    print_status "$BLUE" "Creating backup of existing files..."
    
    local files_backed_up=()
    
    # Create backup directory only for real installs
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$BACKUP_DIR"
    fi
    
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
        if [ "$DRY_RUN" = true ]; then
            print_status "$BLUE" "Would back up ${#files_backed_up[@]} files to: $BACKUP_DIR"
        else
            print_status "$GREEN" "✅ Backed up ${#files_backed_up[@]} files to: $BACKUP_DIR"
        fi
        if [ "$VERBOSE" = true ] || [ "$DRY_RUN" = true ]; then
            for file in "${files_backed_up[@]}"; do
                echo "  - $file"
            done
        fi
    else
        print_status "$YELLOW" "No existing files to backup"
        if [ "$DRY_RUN" = false ]; then
            rmdir "$BACKUP_DIR" 2>/dev/null || true
        fi
    fi
}

# Enhanced link function with validation
link() {
    local source="$DOTFILES_DIR/$1"
    local target="$2"
    local target_dir
    target_dir=$(dirname "$target")
    
    # Validate source exists
    if [ ! -e "$source" ]; then
        print_status "$RED" "❌ Source file does not exist: $source"
        return 1
    fi
    
    # Create target directory if needed
    if [ ! -d "$target_dir" ]; then
        if [ "$DRY_RUN" = false ]; then
            mkdir -p "$target_dir"
        fi
        if [ "$VERBOSE" = true ]; then
            print_status "$BLUE" "Created directory: $target_dir"
        fi
    fi
    
    # Show what we're doing
    if [ "$DRY_RUN" = true ]; then
        echo "Would link: $source --> $target"
        if [ -e "$target" ] || [ -L "$target" ]; then
            echo "Would replace existing target before linking: $target"
        fi
    else
        if [ -L "$target" ]; then
            rm "$target"
        elif [ -e "$target" ]; then
            if [ "$CREATE_BACKUP" = false ]; then
                print_status "$RED" "❌ Target already exists and backups are disabled: $target"
                print_status "$YELLOW" "   Re-run with --backup or move the existing path out of the way."
                return 1
            fi
            rm -rf "$target"
        fi

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
    print_status "$BLUE" "Installing dotfiles..."
    
    # Create logs directory
    if [ "$DRY_RUN" = false ]; then
        mkdir -p "$HISTORY_LOGS"
    fi
    
    local link_errors=0
    
    # Link home files
    for file in $HOME_FILES; do
        if ! link "$HOME_SOURCE_DIR/$file" "$HOME/.$file"; then
            ((link_errors++))
        fi
    done
    
    # Link config files
    for file in $CONFIG_FILES; do
        if ! link "$CONFIG_SOURCE_DIR/$file" "$HOME/.config/$file"; then
            ((link_errors++))
        fi
    done
    
    if [ $link_errors -gt 0 ]; then
        print_status "$RED" "❌ $link_errors linking errors occurred"
        return 1
    else
        print_status "$GREEN" "✅ All files linked successfully"
    fi
}

# Verify installation
verify_installation() {
    if [ "$DRY_RUN" = true ]; then
        return 0
    fi
    
    print_status "$BLUE" "Verifying installation..."
    
    local verification_errors=0
    
    # Verify home files
    for file in $HOME_FILES; do
        local target="$HOME/.$file"
        if [ -L "$target" ]; then
            local link_target
            link_target=$(readlink "$target")
            if [ "$link_target" = "$DOTFILES_DIR/$HOME_SOURCE_DIR/$file" ]; then
                if [ "$VERBOSE" = true ]; then
                    print_status "$GREEN" "✅ $target correctly linked"
                fi
            else
                print_status "$RED" "❌ $target points to wrong location: $link_target"
                ((verification_errors++))
            fi
        else
            print_status "$RED" "❌ $target is not a symlink"
            ((verification_errors++))
        fi
    done
    
    # Verify config files
    for file in $CONFIG_FILES; do
        local target="$HOME/.config/$file"
        if [ -L "$target" ]; then
            local link_target
            link_target=$(readlink "$target")
            if [ "$link_target" = "$DOTFILES_DIR/$CONFIG_SOURCE_DIR/$file" ]; then
                if [ "$VERBOSE" = true ]; then
                    print_status "$GREEN" "✅ $target correctly linked"
                fi
            else
                print_status "$RED" "❌ $target points to wrong location: $link_target"
                ((verification_errors++))
            fi
        else
            print_status "$RED" "❌ $target is not a symlink"
            ((verification_errors++))
        fi
    done
    
    if [ $verification_errors -gt 0 ]; then
        print_status "$RED" "❌ $verification_errors verification errors found"
        return 1
    else
        print_status "$GREEN" "✅ Installation verified successfully"
    fi
}

# Bootstrap Tmux Plugin Manager so it can install plugins declared in tmux.conf
install_tpm() {
    print_status "$BLUE" "Installing Tmux Plugin Manager..."

    if [ "$DRY_RUN" = true ]; then
        if [ -e "$TPM_INSTALL_DIR" ]; then
            echo "TPM already exists at: $TPM_INSTALL_DIR"
        else
            echo "Would install TPM from $TPM_REPO_URL to: $TPM_INSTALL_DIR"
        fi
        return 0
    fi

    case "${DOTFILES_SKIP_TPM_BOOTSTRAP:-false}" in
        1|true|TRUE|yes|YES)
            print_status "$YELLOW" "Skipping TPM bootstrap because DOTFILES_SKIP_TPM_BOOTSTRAP is set"
            return 0
            ;;
    esac

    if [ -x "$TPM_INSTALL_DIR/tpm" ]; then
        print_status "$GREEN" "✅ TPM already installed at: $TPM_INSTALL_DIR"
        return 0
    fi

    if [ -e "$TPM_INSTALL_DIR" ]; then
        print_status "$RED" "❌ TPM install path exists but does not contain an executable tpm script: $TPM_INSTALL_DIR"
        print_status "$YELLOW" "   Remove the path or install TPM there manually, then re-run the installer."
        return 1
    fi

    mkdir -p "$(dirname "$TPM_INSTALL_DIR")"

    if [ "$VERBOSE" = true ]; then
        echo "Cloning TPM: $TPM_REPO_URL --> $TPM_INSTALL_DIR"
    fi

    git clone --depth 1 "$TPM_REPO_URL" "$TPM_INSTALL_DIR"

    if [ -x "$TPM_INSTALL_DIR/tpm" ]; then
        print_status "$GREEN" "✅ TPM installed successfully"
    else
        print_status "$RED" "❌ TPM clone completed, but expected executable was not found: $TPM_INSTALL_DIR/tpm"
        return 1
    fi
}

# Print next steps
print_next_steps() {
    print_status "$BLUE" "Next steps:"
    echo ""
    echo "1. Bootstrap Neovim plugins with lazy.nvim:"
    echo "   nvim"
    echo "   # or run non-interactively:"
    echo "   nvim -c 'Lazy install' -c 'qa'"
    echo ""
    echo "2. Install tmux plugins with TPM:"
    echo "   tmux source-file ~/.config/tmux/tmux.conf"
    echo "   # Then press prefix + I inside tmux"
    echo ""
    echo "3. Install Homebrew packages:"
    echo "   brew bundle --file=$DOTFILES_DIR/Brewfile"
    echo ""
    echo "4. Restart your shell or run:"
    echo "   source ~/.zshrc"
    echo ""
    if [ "$CREATE_BACKUP" = true ] && [ -d "$BACKUP_DIR" ]; then
        echo "5. Your original files are backed up in:"
        echo "   $BACKUP_DIR"
        echo ""
    fi
}

# Main execution
main() {
    print_status "$BLUE" "🏠 Enhanced Dotfiles Installation"
    echo "================================="
    
    if [ "$DRY_RUN" = true ]; then
        print_status "$YELLOW" "DRY RUN MODE - No changes will be made"
    fi
    
    check_requirements
    create_backup
    install_dotfiles
    verify_installation
    install_tpm
    
    echo "================================="
    
    if [ "$DRY_RUN" = true ]; then
        print_status "$BLUE" "Dry run completed successfully!"
        print_status "$YELLOW" "Run without --dry-run to perform actual installation"
    else
        print_status "$GREEN" "🎉 Installation completed successfully!"
        print_next_steps
    fi
}

main "$@"
