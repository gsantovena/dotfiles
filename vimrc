"---------------------------------------------
" gsantovena@gmail.com
"
" References:
" http://dougblack.io/words/a-good-vimrc.html
" https://amix.dk/vim/vimrc.html
" https://github.com/sjl/badwolf/
" https://github.com/michaeljsmalley/dotfiles
"---------------------------------------------

call plug#begin()
Plug 'fatih/vim-go'
call plug#end()

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
syntax enable
"filetype on
"filetype plugin on
filetype plugin indent on
set t_Co=256
colorscheme badwolf
"colorscheme desert

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
set autowrite
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
" autocmd FileType go nmap <leader>b :GoBuild<CR>
autocmd FileType go nmap <leader>r :GoRun<CR>
autocmd FileType go nmap <leader>t :GoTest<CR>

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#cmd#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>c :GoCoverageBrowser<CR>

let g:go_fmt_command = "goimports"

