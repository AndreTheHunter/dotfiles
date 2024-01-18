function subl
	function _get_sublime_project -a dir
		set dir (realpath $dir)
		set project $dir/(basename $dir).sublime-project
		if test -e $project
			echo "$project"
		end
	end
	if test (count $argv) -eq 0
		set argv (_get_sublime_project $PWD)
	else if begin; test (count $argv) -eq 1; and test -d $argv[1]; end
		set project (_get_sublime_project $argv[1])
		if test -n "$project"
			set argv[1] $project
		end
	end
	command subl $argv
end
