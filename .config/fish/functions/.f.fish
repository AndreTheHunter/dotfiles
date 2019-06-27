# Defined in - @ line 1
function .f --description 'alias .f git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
	git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv;
end
