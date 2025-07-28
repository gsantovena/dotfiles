# Gerardo Santoveña's dotfiles
My dot files

## Introduction
This repository contains my personal dotfiles, which are configuration files for various applications and tools I use. The goal is to keep my environment consistent across different machines and to share my setup with others.

## Changed from Vim to Neovim
I have transitioned from using Vim to Neovim as my primary text editor. Neovim offers several enhancements over Vim, including better plugin support, asynchronous processing, and a more modern architecture.

## Requirements
To use these dotfiles, you will need the following:
- Homebrew
- Neovim
- Zsh
- Git

## Installation
To set up my dotfiles, follow these steps:
1. Clone the repository:
   ```bash
   git clone git@github.com:gsantovena/dotfiles.git ~/.dotfiles
   ```
2. Navigate to the cloned directory:
   ```bash
   cd ~/.dotfiles
   ```
3. Run the installation script:
   ```bash
   ./install-dotfiles.sh
   ```

## Neovim Configuration

Install Plugged:
```bash
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

You will have an alias `vi` that points to `nvim`. To install the plugins, open Neovim and run:
```vim
:PlugInstall
```

