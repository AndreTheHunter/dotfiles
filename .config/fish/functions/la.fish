function la --wraps=ls
	set -l cmd
	if is-mac
		set cmd gls
	else
		set cmd ls
	end
	set cmd command $cmd -lv --all --color --group-directories-first --human-readable --kibibytes --tabsize=$TAB_WIDTH --time-style=long-iso $argv
	eval $cmd
end
