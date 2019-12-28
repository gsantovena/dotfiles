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

call plug#begin()
Plug 'fatih/vim-go'
Plug 'derekwyatt/vim-scala'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rizzatti/dash.vim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'python-mode/python-mode', { 'branch': 'develop' }
Plug 'Konfekt/FastFold'
Plug 'dylanaraps/root.vim'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'xavierchow/vim-sequence-diagram'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tpope/vim-fugitive'
Plug 'hashivim/vim-terraform'
Plug 'vim-airline/vim-airline'
Plug 'tpope/vim-surround'
Plug 'aquach/vim-http-client'
Plug 'rodjek/vim-puppet'

if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
call plug#end()

" Automatically reloads on vimrc changes
augroup myvimrc
    au!
    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
augroup END

" Persistent Undo
let s:undoDir = "/tmp/.undodir_" . $USER
if !isdirectory(s:undoDir)
    call mkdir(s:undoDir, "", 0700)
endif
let &undodir=s:undoDir
set undofile

set autoindent
set cursorline
set foldmethod=marker
set lazyredraw
set number
set ruler
set showcmd
set showmatch
set title
set wildmenu
set wildmode=list:longest,full
set showbreak=↪

" Tabs
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" Colors
syntax enable
"filetype on
"filetype plugin on
filetype plugin indent on
set t_Co=256
"colorscheme zenburn
colorscheme badwolf
"colorscheme desert

"let vim_markdown_preview_toggle=1
let vim_markdown_preview_github=1
let vim_markdown_preview_browser='Google Chrome'

let g:generate_diagram_theme_hand=1

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

" Shortcuts
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>o :only<CR>

noremap + <C-a>
noremap - <C-x>

xnoremap + g<C-a>
xnoremap - g<C-x>

nmap <F8> :TagbarToggle<CR>
map <F10> :NERDTreeToggle<CR>

cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" UltiSnips Configuration
let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<c-b>"
"let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

" root.vim
let g:root#auto = 1
let g:root#echo = 0

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

" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3

if !exists('g:neocomplete#sources')
    let g:neocomplete#sources = {}
endif

let g:neocomplete#sources._ = ['buffer', 'member', 'tag', 'file', 'dictionary']
let g:neocomplete#sources.go = ['omni']

"call neocomplete#custom#source('_', 'sorters', [])
let g:deoplete#enable_at_startup = 1

let g:pymode_python = 'python3'

" vim-airline configurations
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

func! WordProcessorMode()
    setlocal formatoptions=1
    setlocal noexpandtab
    map j gj
    map k gk
    setlocal spell spelllang=en_us
    set thesaurus+=/Users/gsantovena/.vim/thesaurus/mthesaur.txt
    set complete+=s
    set formatprg=par
    setlocal wrap
    setlocal linebreak
endfu
com! WP call WordProcessorMode()

