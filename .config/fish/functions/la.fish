function la --wraps=ls
	gls -lv --all --color --group-directories-first --human-readable --kibibytes --no-group --tabsize=$TAB_WIDTH --time-style=long-iso $argv
end
