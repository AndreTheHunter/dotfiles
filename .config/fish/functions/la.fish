function la --wraps=ls
	set -l cmd
	if is-mac
		set cmd gls
	else
		set cmd ls
	end
	command $cmd -lv --all --group-directories-first --human-readable --kibibytes --color=auto --tabsize=$TAB_WIDTH --time-style=long-iso $argv
end
