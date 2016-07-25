#!/bin/bash

HISTORY_LOGS=~/.logs
DOTFILES_DIR=~/dotfiles
FILES="bash_profile aliases exports functions vim vimrc zshrc"

mkdir -p "${HISTORY_LOGS}"

link() {
    # Force create/replace the symlink.
    echo "${DOTFILES_DIR}/${1} --> ${HOME}/${2}"
    ln -sf "${DOTFILES_DIR}/${1}" "${HOME}/${2}"
}

if [ -e "${HOME}/.vim" ]; then
    rm -rf "${HOME}/.vim"
fi

for FILE in $FILES
do
    link "$FILE" ".$FILE"
done

