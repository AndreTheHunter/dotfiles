# Defined in - @ line 1
function .s --description 'alias .s git --git-dir=$HOME/.dotfiles-secret/ --work-tree=$HOME'
	git --git-dir=$HOME/.dotfiles-secret/ --work-tree=$HOME $argv;
end
