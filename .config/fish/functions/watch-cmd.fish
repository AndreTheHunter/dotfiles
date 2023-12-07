function watch-cmd
	set -l file $argv[1]
	set -l cmd $argv[2]
	if test -z "$cmd"
		set cmd "$file"
		set file '.'
	end
	ls $file | entr -ccsn "$cmd"
end
