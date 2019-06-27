function for-line -S -a file forlinecallback
	if test -z $file
		err 'ERROR: file not set'
		return 1
	end

	if not test -r $file
		err "Can't read file" $file
		return 1
	end

	for line in (cat $file)
		set line (trim $line)

		#skip empty lines
		if test -z $line
			continue
		end

		#skip comment lines
		if echo $line | grep '^[[:space:]]*#' -q
			continue
		end

		if not eval $forlinecallback $line
			return 1
		end
	end
end
