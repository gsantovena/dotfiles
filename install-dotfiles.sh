#!/bin/bash

dir=~/dotfiles
files="bash_profile vim vimrc zshrc"

for file in $files
do
    echo "Creating symlink to $file in home directory."
    rm ~/.$file
    ln -sf $dir/$file ~/.$file
done

