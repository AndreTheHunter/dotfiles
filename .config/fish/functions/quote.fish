function quote
	set -l delim \x1
	for arg in $argv
		# escape quotes
		set sq "'"
		set arg (echo $arg|sed "s$delim'$delim\\\\'$delim")
		set args $args "'$arg'"
	end
	if set -q args
		echo $args
	end
	return 0
end
