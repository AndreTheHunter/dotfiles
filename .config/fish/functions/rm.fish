function rm --description 'alias rm grm -I --one-file-system'
	set -l cmd
	if is-mac
		set cmd grm
	else
		set cmd rm
	end	
	command $cmd -I --one-file-system $argv
end
