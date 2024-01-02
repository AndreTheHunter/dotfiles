set nocompatible
set shell=bash

filetype on
filetype plugin on
filetype indent on
syntax enable

colorscheme solarized

set autoindent
set autoread
set background=dark
set colorcolumn=80
set copyindent
set cursorline
set ignorecase
set modelines=1
set mouse=a
set noexpandtab
set noswapfile
set nowrap
set number
set preserveindent
set relativenumber
set ruler
set shiftwidth=2
set smartcase
set smartindent
set softtabstop=2
set spell spelllang=en_au
set tabstop=2
set undofile
set wildmenu

autocmd filetype gitcommit setlocal spell textwidth=72 colorcolumn=72
autocmd filetype crontab setlocal nobackup nowritebackup

" Clear trailing whitespace
autocmd BufWritePre *.js :%s/\s\+$//e

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

" ignores
set wildignore+=*/node_modules/*,.git,*/target/*

" filetypes
au BufRead,BufNewFile .env* set filetype=sh
au BufRead,BufNewFile Brewfile set filetype=ruby
au BufRead,BufNewFile .Brewfile set filetype=ruby

" Parinfer
let g:parinfer_preview_cursor_scope = 1
let g:parinfer_mode = "indent"

" shared keys
source $HOME/.vim/keys.vim
