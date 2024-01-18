function parents
	set -l dir $argv
	if test (count $dir) -eq 0
		set dir $PWD
	end
	set -l path (echo $dir|tr '/' '\n')
	while test (count $path) -gt 0
		set -e path[-1]
		if test (count $path) -gt 1
			string join '/' $path
		else if test (count $path) -eq 1
			echo '/'
		end
	end
end
