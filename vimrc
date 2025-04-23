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

set encoding=utf-8

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
Plug 'nathanaelkane/vim-indent-guides'
Plug 'vitapluvia/vim-gurl'

Plug 'vim-denops/denops.vim'
Plug 'vim-denops/denops-helloworld.vim'

Plug 'Shougo/ddc.vim'
Plug 'Shougo/ddc-ui-native'
Plug 'Shougo/ddc-source-around'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
Plug 'Shougo/ddu.vim'

Plug 'github/copilot.vim'

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
set mouse=a
set number
set ruler
set showbreak=↪
set showcmd
set showmatch
set title
set wildmenu
set wildmode=list:longest,full

" Leader Shortcut
let mapleader=","

" Tabs
nnoremap <Leader>p :tabprevious<CR>
nnoremap <Leader>n :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" Yank to system clipboard
vnoremap <Leader>v "+y

" Colors
syntax enable
"filetype on
"filetype plugin on
filetype plugin indent on
set t_Co=256

" badwolf.vim dracula.vim molokai.vim zenburn.vim
"colorscheme badwolf
"colorscheme desert
"colorscheme dracula
colorscheme molokai
"colorscheme zenburn


"let vim_markdown_preview_toggle=1
let vim_markdown_preview_github=1
let vim_markdown_preview_browser='Google Chrome'

let g:generate_diagram_theme_hand=1

" Spaces & Tabs
set backspace=2
set expandtab
set shiftwidth=2
set shiftround
set smarttab
set softtabstop=2
set tabstop=2

" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

" Shortcuts
nnoremap <leader><space> :nohlsearch<CR>
nnoremap <leader>o :only<CR>

noremap <leader>gr :call Gurl()<CR>

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

"com! FormatJSON %!python -m json.tool
com! FormatJSON %!jq

" Customize global settings

" You must set the default ui.
" Note: native ui
" https://github.com/Shougo/ddc-ui-native
call ddc#custom#patch_global('ui', 'native')

" Use around source.
" https://github.com/Shougo/ddc-source-around
call ddc#custom#patch_global('sources', ['around'])

" Use matcher_head and sorter_rank.
" https://github.com/Shougo/ddc-matcher_head
" https://github.com/Shougo/ddc-sorter_rank
call ddc#custom#patch_global('sourceOptions', #{
      \ _: #{
      \   matchers: ['matcher_head'],
      \   sorters: ['sorter_rank']},
      \ })

" Change source options
call ddc#custom#patch_global('sourceOptions', #{
      \   around: #{ mark: 'A' },
      \ })
call ddc#custom#patch_global('sourceParams', #{
      \   around: #{ maxSize: 500 },
      \ })

" Customize settings on a filetype
call ddc#custom#patch_filetype(['c', 'cpp'], 'sources',
      \ ['around', 'clangd'])
call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', #{
      \   clangd: #{ mark: 'C' },
      \ })
call ddc#custom#patch_filetype('markdown', 'sourceParams', #{
      \   around: #{ maxSize: 100 },
      \ })

" Mappings

" <TAB>: completion.
inoremap <silent><expr> <TAB>
\ pumvisible() ? '<C-n>' :
\ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
\ '<TAB>' : ddc#map#manual_complete()

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? '<C-p>' : '<C-h>'

" Use ddc.
call ddc#enable()

" Mappings to access buffers (don't use "\p" because a
" delay before pressing "p" would accidentally paste).
" \l       : list buffers
" \b \f \g : go back/forward/last-used
" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <Leader>l :ls<CR>
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>
nnoremap <Leader>0 :10b<CR>
" It's useful to show the buffer number in the status line.
set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
