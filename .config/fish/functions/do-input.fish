function do-input
	set result 1
	if test (count $argv) -eq 0
		while read -l line
			do $line
			set result $status
			if test $result -ne 0
				break
			end
		end
	else
		do $argv
		set result $status
	end
	functions -e do
	return $result
end
