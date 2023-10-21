function la --wraps=ls
	command ls -lv --all --color --group-directories-first --human-readable --kibibytes --tabsize=$TAB_WIDTH --time-style=long-iso $argv
end
