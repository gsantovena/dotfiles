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

I use [neocomplete.vim](https://github.com/Shougo/neocomplete.vim) for completion.
You will need Vim 7.3.885+ compiled with lua to use it.

Another plugin I've started to use is 'majutsushi/tagbar'. This plugin will need 'ctags' installed.

## Installation

I highly recommend to install [oh-my-zsh](http://ohmyz.sh/) first.

```bash
git clone git@github.com:gsantovena/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install-dotfiles.sh
```
This will create symlinks in your $HOME to the files listed in the variable 'files' within the script.
![demo](https://raw.githubusercontent.com/gsantovena/dotfiles/master/dotfiles_s.gif)

## References
- [Paul's dotfiles](https://github.com/paulirish/dotfiles)
- [Mathias's dotfiles](https://github.com/mathiasbynens/dotfiles)
- [Nicolas Gallagher's dotfiles](https://github.com/necolas/dotfiles)
- [Zsh](http://www.zsh.org/)
- [oh-my-zsh](http://ohmyz.sh/)
- [Mac CLI](https://github.com/guarinogabriel/Mac-CLI)
- [m-cli](https://github.com/rgcr/m-cli)
