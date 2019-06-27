function filter
	if test (count $argv) -eq 0
		err 'No commands specified'
		return 1
	end
	set argv (quote $argv)
	while read -l line
		if echo $line | sush eval $argv
			echo $line
		end
	end
	return 0
end
