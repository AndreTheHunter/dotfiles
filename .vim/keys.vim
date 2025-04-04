" Search and replace on selection
vnoremap <leader>s y:%s/<c-r>"//gc<left><left><left>

" Esc shortcuts
inoremap jk <esc>
inoremap <leader>jk <esc>

" Paste commands
vnoremap <leader>y "+yy
inoremap <leader>p <c-r>*
nnoremap <leader>p "*p
nnoremap <leader>P "*P

" Navigation
nnoremap H ^
nnoremap L $
nnoremap <leader>H H
nnoremap <leader>L L
vnoremap H ^
vnoremap L $
vnoremap <leader>H H
vnoremap <leader>L L
onoremap H ^
onoremap L $
onoremap <leader>H H
onoremap <leader>L L

" Indent
vnoremap <tab> >
vnoremap <s-tab> <

" put search matches at centre screen
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz

" toggle fold
nnoremap <space> za
