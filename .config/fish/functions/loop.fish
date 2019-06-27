function loop
	if echo $argv | grep -q '\{.*\}'
	else
		eval $argv
		return $status
	end
	set len (seq (count $argv))
	for i in $len
		set arg $argv[$i]
		#skip if not brackets arg
		if echo $arg | grep -q '\{.*\}'
		else
			continue
		end
		eval "set arg $arg"
		for part in $arg
			set cmd
			for j in $len
				#if this is the brackets arg...
				if test $j -eq $i
					#set to resolved segment
					set cmd[$j] (quote "$part")
				else
					#set as normal arg
					set cmd[$j] (quote "$argv[$j]")
				end
			end
			eval $cmd
		end
	end
end
