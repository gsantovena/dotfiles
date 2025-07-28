#!/bin/bash

HISTORY_LOGS=${HOME}/.logs
DOTFILES_DIR=$(git rev-parse --show-toplevel)
HOME_FILES="bash_profile aliases exports functions git gitconfig vim zshrc secrets screenrc"
CONFIG_FILES="nvim"

mkdir -p "${HISTORY_LOGS}"

link() {
  echo "${DOTFILES_DIR}/${1} --> ${2}"
  ln -sf "${DOTFILES_DIR}/${1}" "${2}"
}

# This is a dirty way to do it.
# It was creating a .vim directory inside ~/.vim, an inception kind of thing
if [ -e "${HOME}/.vim" ]; then
    rm -rf "${HOME}/.vim"
fi

for FILE in ${HOME_FILES}
do
    link "${FILE}" "${HOME}/.${FILE}"
done

for FILE in ${CONFIG_FILES}
do
    link "${FILE}" "${HOME}/.config/${FILE}"
done
