# Gerardo Santoveña's dotfiles
My dot files

## Description
Some dot files useful for me. Be free to use them.

I have installed [zsh](http://www.zsh.org/) and [oh-my-zsh](http://ohmyz.sh/).

Vim stuff:
- Color schemes: [badwolf](https://github.com/sjl/badwolf), [molokai](https://github.com/tomasr/molokai), [dracula](https://github.com/dracula/vim)
- Language syntax: Scala, Go
- Go development plugin for Vim: [vim-go](https://github.com/fatih/vim-go)
- Vim Plugin Manager: [vim-plug](https://github.com/junegunn/vim-plug)

```bash
vim -c "PlugInstall" -c "qa"
```

## Installation

I highly recommend to install [oh-my-zsh](http://ohmyz.sh/) first.

```bash
git clone git@github.com:gsantovena/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install-dotfiles.sh
```
This will create symlinks in your $HOME to the files listed in the variable 'files' within the script.
![demo](https://raw.githubusercontent.com/gsantovena/dotfiles/master/dotfiles_s.gif)

Other considerations:
- I use [neocomplete.vim](https://github.com/Shougo/neocomplete.vim) for completion.  You will need Vim 7.3.885+ compiled with lua to use it.
- Another plugin I've started to use is [majutsushi/tagbar](https://github.com/majutsushi/tagbar). This plugin will need `ctags` installed.
- To have the cool themes for Vim and Oh-My-Zsh, you will need to install [powerline/fonts](https://github.com/powerline/fonts).

## ZSH Plugins I use
- aws 
- brew 
- brew-cask 
- command-not-found 
    - `brew tap homebrew/command-not-found`
- docker 
- docker-compose 
- git 
- github
    - `brew install hub`
- gitignore
- go 
- knife 
- knife_ssh
- mvn 
- mosh
- nmap 
- osx 
- pyenv 
- ssh-agent
- taskwarrior
    - `brew install task`
    - `brew install taskd`
    - `brew install tasksh`
- terraform 
- thefuck
- vagrant 
- vault 
- virtualenv
- web-search
- z

## Github Atom

Lately, I have been using [Atom](https://atom.io) a lot, hence I have installed some packages. And to save which ones I use and restore them in a easy way, I have just added a file listing them.

I found two ways to backup and restore the atom packages:

### Method 1:

Starring the packages and to restore them: `apm starred --install`

### Method 2:

Backup: `apm list --installed --bare > atom-packages.list`
Restore: `apm install --packages-file atom-packages.list`

## References
- [Paul's dotfiles](https://github.com/paulirish/dotfiles)
- [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Nicolas Gallagher's dotfiles](https://github.com/necolas/dotfiles)
- [Zsh](http://www.zsh.org/)
- [oh-my-zsh](http://ohmyz.sh/)
- [Mac CLI](https://github.com/guarinogabriel/Mac-CLI)
- [m-cli](https://github.com/rgcr/m-cli)
- [Writing in Vim](http://www.drbunsen.org/writing-in-vim/)
- [mthesaur.txt](http://www.gutenberg.org/files/3202/files/mthesaur.txt)

Also check the Plug section in the vimrc file for other requirements to have all Vim plugins working.

