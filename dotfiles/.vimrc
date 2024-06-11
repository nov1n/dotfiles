scriptencoding utf-8
set encoding=utf-8
set fileencoding=utf-8
set nocompatible                            " Only compile as vim
set t_Co=256                                " Support 256bit terminal colors
set hidden                                  " Allow buffer switch w/o saving
let $FZF_DEFAULT_COMMAND= 'ag --ignore vendor --ignore .git -g ""'

call plug#begin()
Plug 'airblade/vim-gitgutter'             " Shows git edits in gutter
Plug 'bling/vim-airline'                  " Improved status bar
Plug 'ConradIrwin/vim-bracketed-paste'    " Handle paste mode before pasting with ctl-shift-v
Plug 'ervandew/supertab'                  " Autocomplete with tab
" Plug 'fatih/vim-go'                       " Go support
" Plug 'junegunn/fzf.vim'                   " Fuzzy file finding
" Plug '/usr/local/opt/fzf'                 " Fzf executable
Plug 'junegunn/goyo.vim'                  " Distraction free writing
" Plug 'klen/python-mode'                   " Do all python things
Plug 'maralla/completor.vim'              " Async autocompletion
" Plug 'mileszs/ack.vim'                    " Searching
Plug 'moll/vim-bbye'                      " Sane buffer closing
" Plug 'morhetz/gruvbox'                    " Theme
" Plug 'honza/vim-snippets'                 " Snippet library
Plug 'nelstrom/vim-visual-star-search'    " Use * to search visual selection
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }
Plug 'raimondi/delimitmate'               " Auto close brackets etc
" Plug 'scrooloose/nerdtree'                " File explorer
Plug 'sheerun/vim-polyglot'               " Language pack
" Plug 'SirVer/ultisnips'                   " Snippet support
Plug 'tomtom/tcomment_vim'                " Add comment shortcuts
" Plug 'tpope/vim-fugitive'                 " Git wrapper
" Plug 'tpope/vim-rhubarb'                  " Github browsing with :Gbrowse
" Plug 'tpope/vim-surround'                 " Surround with
Plug 'tpope/vim-unimpaired'               " Bracket mappings
Plug 'vim-airline/vim-airline-themes'     " Themes for airline
" Plug 'connorholyday/vim-snazzy'           " Theme
Plug 'w0rp/ale'                           " Async linters
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }}
" Plug 'aserebryakov/vim-todo-lists'
Plug 'ojroques/vim-oscyank', {'branch': 'main'} " Yank over ssh
call plug#end()

filetype plugin indent on                   " Expose filetype
syntax on                                   " Enable syntax highlighting
" colorscheme snazzy

set number                                  " Show line numbers
set relativenumber                          " Show relative numbers
set incsearch                               " Search on keyup
set ignorecase                              " Case insensitive search
set smartcase                               " Be smart about case when searching
set hlsearch                                " Highlight all occurrences
set list                                    " Show tabs as |
" set listchars=tab:\ ,trail:·,eol:¬,nbsp:_
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

set backspace=indent,eol,start              " Backspace behaves normally
set mouse=a

nnoremap <C-J> <C-W><C-J>|                  " Easier navigation in splits
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

vnoremap <Tab> >|                           " Indent with tab in visual mode
vnoremap <S-Tab> <

noremap <leader>cc :TComment<CR>|           "Toggle comments
noremap <leader>cb :TCommentBlock<CR>|      "Toggle comments as a block

set splitbelow                              " Open new splits below and right
set splitright

cnoreabbrev Wq wq|                          " Correct common spelling mistakes
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q

nnoremap <silent><C-b> :<C-u>nohlsearch<CR><C-l>| " Remove highlighting
nnoremap <C-b> :nohl<CR>
nmap <leader>w :w!<cr>|                     " Use w! by default
set so=7                                    " Set 7 lines to the cursor

set ruler                                   " Show ruler

set showmatch                               " Show matching brackets
set mat=2                                   " Blink time

set noerrorbells                            " No annoying sound on errors
set novisualbell
set t_vb=
set tm=500

set background=dark                         " Use dark background

set ffs=unix,dos,mac                        " Use Unix as standard filetype

set noswapfile                              " Disable swap and backup measures set nowb
set nobackup

set expandtab                               " Use spaces instead of tabs
set smarttab                                " Be smart with tabs
set shiftwidth=4                            " 1 tab == 4 spaces
set tabstop=4
set autoindent                              " Set auto indent
set smartindent                             " Set smart indent
"set wrap                                    " Wrap lines

map j gj|                                   " Treat long lines as break lines
map k gk

set clipboard=unnamed                   " Alias the unnamed register to the + register (clipboard)

set laststatus=2                            " Always show status line

set guioptions-=m                           " Remove menu bar
set guioptions-=T                           " Remove toolbar
set guioptions-=r                           " Remove right-hand scroll bar
set guioptions-=L                           " Remove left-hand scroll bar

let delimitMate_expand_cr = 1 |             " Auto indent after bracket

inoremap jk <Esc>|                          " Experimental

                                            " Omnicomplete
inoremap <expr> <C-Space> pumvisible() \|\| &omnifunc == '' ?
            \ "\<lt>C-n>" :
            \ "\<lt>C-x>\<lt>C-o><c-r>=pumvisible() ?" .
            \ "\"\\<lt>c-n>\\<lt>c-p>\\<lt>c-n>\" :" .
            \ "\" \\<lt>bs>\\<lt>C-n>\"\<CR>"
imap <C-@> <C-Space>

                                            " Make powerline work on windows
let g:airline_powerline_fonts = 1
let g:airline_theme='wombat'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1

" Automatically insert import paths
let g:go_fmt_command = "goimports"

" Exclude vendor directory from searc
set wildignore+=*vendor/*

" Fix go save hangup, remove 'go' if slow
let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Open nerdtree on open
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-n> :NERDTreeToggle<CR>

" Close nerdtree when it's the only window left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Folding
set foldmethod=syntax
set foldnestmax=1
set foldlevel=20

" Close buffers with \q
:nnoremap <Leader>q :Bdelete<CR>

" Make the tee hack easier
cmap w!! w !sudo tee > /dev/null %

" Go keybindings
"au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)

au FileType go nmap <leader>gk <Plug>(go-doc-browser)
au FileType go nmap <leader>gi <Plug>(go-info)
au FileType go nmap <leader>gr <Plug>(go-rename)
au FileType go nmap <leader>gm :GoImport

" Use gometalinter (combines different linters)
" let g:ale_linters = {'go': ['gometalinter']}

" Autocompletion with gocode
let g:completor_gocode_binary = '/home/robert/Code/go/bin/gocode'

" Snippets
au FileType go imap <C-e> if err != nil {<CR>
let g:UltiSnipsJumpForwardTrigger="<c-f>"
let g:UltiSnipsJumpBackwardTrigger="<c-b>"

let g:SuperTabDefaultCompletionType = "context"

" Python PEP8
au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Plugins are sourced after this file which overrides mappings, the following
" commands are loaded after plugin rc files.
"
" These bindings are special and loaded after plugin to overwrite mappings
" defined by plugins
" https://vi.stackexchange.com/questions/756/how-can-i-redefine-plugin-key-mappings
au VimEnter * inoremap <S-Tab> <Esc>la

" Rerun last command in top right tmux pane
"                                  session:window.pane
nmap <leader>r :!tmux send-keys -t main:dev.1 C-p C-j<CR><CR>

" fzf keybindings
nmap , :Buffers<CR>
imap <C-t> <Esc> :Files<CR>
nmap <C-t> :Files<CR>

" Prose mode
function! ProseMode()
  call goyo#execute(0, [])
  set spell noci nosi noai nolist noshowmode noshowcmd
  set complete+=s
  set bg=light
endfunction

command! ProseMode call ProseMode()
nmap \p :ProseMode<CR>

if has('ide')
    " Press `f` to activate AceJump
    map f :action AceAction<CR>
    " Press `F` to activate Target Mode
    map F :action AceDeclarationAction<CR>
endif

imap <C-BS> <C-W>
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

cnoremap sudow w !sudo tee % >/dev/null
