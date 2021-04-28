if !exists('g:vscode') 
	call plug#begin('~/.local/share/nvim/plugged')
	source ~/.vim/plugins.vim
	call plug#end()
endif
source $HOME/.vim/common.vim
