#!/bin/bash

dir=~/dotfiles
files="bash_profile vim vimrc"

for file in $files
do
    echo "Creating symlink to $file in home directory."
    ln -sf $dir/$file ~/.$file
done

