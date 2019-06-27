function isBinary
	if test ! -e $argv
		err "File not found: $argv"
		return 1
	end
	# use file command to get the type and look for 'text'
	set -l nonWord '[[:space:]]|[[:punct:]]'
	if file -b $argv|grep -qP "(?<=^|$nonWord)text(?=\$|$nonWord)"
		return 1
	end
end
