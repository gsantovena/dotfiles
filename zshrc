# Modular zsh configuration entrypoint.
#
# The real configuration lives in zsh/*.zsh so each concern can be updated
# independently while this file remains safe to symlink as ~/.zshrc.

_dotfiles_zshrc="${(%):-%N}"
DOTFILES_DIR="${DOTFILES_DIR:-${_dotfiles_zshrc:A:h}}"
unset _dotfiles_zshrc

for file in "$DOTFILES_DIR"/zsh/*.zsh(N); do
    [ -r "$file" ] && source "$file"
done

unset file
