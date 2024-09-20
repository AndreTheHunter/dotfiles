filetype plugin indent on
syntax enable

set autoindent
set autoread
set background=dark
set colorcolumn=80
set copyindent
set cursorline
set ignorecase
set modeline
set modelines=3
set mouse=a
set noexpandtab
set noswapfile
set nowrap
set number
set preserveindent
set relativenumber
set ruler
set shell=bash
set shiftwidth=2
set smartcase
set smartindent
set softtabstop=2
set spell spelllang=en_au
set tabstop=2
set undofile
set wildmenu

colorscheme solarized

augroup vim_plug_sync
	autocmd VimEnter *
  			\  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  			\|   PlugInstall --sync | q
  			\| endif
augroup end

autocmd filetype gitcommit setlocal spell textwidth=72 colorcolumn=72
autocmd filetype crontab setlocal nobackup nowritebackup

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(':DiffOrig')
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
let g:parinfer_mode = 'indent'

" shared keys
source $HOME/.vim/keys.vim
