function .s --description 'alias .s git --git-dir=$HOME/.dotfiles-secret/ --work-tree=$HOME' --wraps 'git'
	git --git-dir=$HOME/.dotfiles-secret/ --work-tree=$HOME $argv;
end
