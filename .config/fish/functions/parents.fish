function parents
	set -l dir $argv
	if test (count $dir) -eq 0
		set dir (pwd)
	end
	set -l path (echo $dir|tr '/' '\n')
	while test (count $path) -gt 0
		set -e path[-1]
		for part in $path
			echo -n "$part/"
		end
		if test (count $path) -gt 0
			echo
		end
	end
end
