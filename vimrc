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
Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'
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

" vim-go
set autowrite

let g:go_fmt_command = "goimports"
let g:go_autodetect_gopath = 1
let g:go_list_type = "quickfix"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_build_constraints = 1

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

nmap <C-g> :GoDeclsDir<CR>
imap <C-g> <ESC>:<C-u>GoDeclsDir<CR>

augroup go
    autocmd!

    autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
    autocmd FileType go nmap <leader>t <Plug>(go-test)
    autocmd FileType go nmap <leader>r <Plug>(go-run)
    autocmd FileType go nmap <leader>d <Plug>(go-doc)
    autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
    autocmd FileType go nmap <leader>C <Plug>(go-coverage-browser)
    autocmd FileType go nmap <leader>i <Plug>(go-info)
    autocmd FileType go nmap <leader>l <Plug>(go-metalinter)
    autocmd FileType go nmap <leader>v <Plug>(go-def-vertical)
    autocmd FileType go nmap <leader>s <Plug>(go-def-split)

    autocmd FileType go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
    autocmd FileType go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
    autocmd FileType go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
    autocmd FileType go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
augroup END

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#cmd#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction

