"---------------------------------------------
" gsantovena@gmail.com
"
" References:
" http://dougblack.io/words/a-good-vimrc.html
" https://amix.dk/vim/vimrc.html
" https://github.com/sjl/badwolf/
" https://github.com/michaeljsmalley/dotfiles
"---------------------------------------------

" UI Config
set nocompatible " get rid of Vi compatibility mode. SET FIRST!

set autoindent
set cursorline
set foldmethod=marker
set lazyredraw
set number
set ruler
set showcmd
set showmatch
set wildmenu
set wildmode=list:longest,full

" Colors
colorscheme badwolf
"colorscheme desert
syntax enable
"filetype on
"filetype plugin on
filetype plugin indent on
set t_Co=256

" Spaces & Tabs
set backspace=2
set expandtab
set shiftwidth=4
set shiftround
set smarttab
set softtabstop=4
set tabstop=4

" Searching
set hlsearch
set incsearch

" Leader Shortcut
let mapleader=","

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Go Language
au BufRead,BufNewFile *.go set filetype=go

