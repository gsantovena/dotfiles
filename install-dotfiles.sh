#!/bin/bash

history_logs=~/.logs
dir=~/dotfiles
files="bash_profile aliases exports functions vim vimrc zshrc"

mkdir -p $history_logs

for file in $files
do
    echo "Creating symlink to $file in home directory."
    rm -f ~/.$file
    ln -sf $dir/$file ~/.$file
done

