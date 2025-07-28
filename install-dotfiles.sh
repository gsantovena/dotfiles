#!/bin/bash

HISTORY_LOGS=${HOME}/.logs
DOTFILES_DIR=$(git rev-parse --show-toplevel)
FILES="bash_profile aliases exports functions git gitconfig vim zshrc secrets screenrc"

mkdir -p "${HISTORY_LOGS}"

link() {
    # Force create/replace the symlink.
    echo "${DOTFILES_DIR}/${1} --> ${HOME}/${2}"
    ln -sf "${DOTFILES_DIR}/${1}" "${HOME}/${2}"
}

# This is a dirty way to do it.
# It was creating a .vim directory inside ~/.vim, an inception kind of thing
if [ -e "${HOME}/.vim" ]; then
    rm -rf "${HOME}/.vim"
fi

for FILE in ${FILES}
do
    link "${FILE}" ".${FILE}"
done

ln -sf "${DOTFILES_DIR}/nvim" "${HOME}/.config/nvim"
