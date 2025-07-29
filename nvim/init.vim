"---------------------------------------------
" gsantovena@gmail.com
" Migrated to Neovim
"---------------------------------------------

" Persistent Undo {{{
let s:undoDir = "/tmp/.undodir_" . $USER
if !isdirectory(s:undoDir)
  call mkdir(s:undoDir, "", 0700)
endif
let &undodir=s:undoDir
set undofile
" }}} Persistent Undo

let g:python3_host_prog = expand('~/.venvs/nvim/bin/python3')

set nocompatible
let mapleader = ","

source ~/.config/nvim/lua/config/showpopup.lua
source ~/.vim/vimrc.plugins
source ~/.vim/vimrc.plugin_config
source ~/.vim/vimrc.ui
source ~/.vim/vimrc.mappings
source ~/.vim/vimrc.personal

" AUTO-RELOAD VIMRC ON SAVE {{{
augroup myvimrc
  au!
  au BufWritePost ~/.config/nvim/init.vim,~/.vimrc,~/.vim/vimrc*,*/vim/vimrc* so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif | call EchoVimrcReloaded()
augroup END
" }}} AUTO-RELOAD VIMRC ON SAVE

