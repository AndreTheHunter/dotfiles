function for-server
	set -l file ~/servers.yaml

	if test $argv[1] = '--_completion'
		set -e argv[1]
		#TODO replace shyaml with a faster utility
		set -l q (cat $file|shyaml keys $argv)
		while test (count $q) -gt 0
			# pop the first key from the queue
			set key $q[1]
			set -e q[1]
			set -l type (cat $file|shyaml get-type $key)
			switch $type
				case sequence
					echo $key
					set -l i 0
					for struct in (cat $file|shyaml get-values $key)
						set q $q "$key.$i"
						set i (expr $i + 1)
					end
				case struct
					echo $key
					for struct in (cat $file|shyaml keys $key)
						set q $q "$key."$struct
					end
				case str
					echo $key
			end
		end
		return 0
	end

	set -l servergroup $argv[1]
	set -e argv[1]

	set -l type (cat $file|shyaml get-type $servergroup ^/dev/null)

	if test -z $type
		err 'Server/group not found: '$servergroup
		return 1
	end

	switch $type
		case sequence
			set -l values (cat $file|shyaml get-values $servergroup)
			set -l i 1
			while test $i -le (count $values)
				set -l name "$servergroup."(expr $i - 1)
				set -l address (quote $values[$i])
				eval "$argv" "$name" "$address"
				set i (expr $i + 1)
			end
		case struct
			set -l values (cat $file|shyaml get-values $servergroup)
			set -l i 1
			while test $i -le (count $values)
				set -l name $values[$i]
				set -l address (quote $values[(expr $i + 1)])
				eval "$argv" "$name" "$address"
				set i (expr $i + 2)
			end
		case str
			set -l address (quote (cat $file|shyaml get-value $servergroup))
			eval "$argv" "$servergroup" "$address"
	end

	# set -l list
	# set q \$$servergroup
	# while test (count $q) -gt 0
	# 	# pop the first key from the queue
	# 	set k $q[1]
	# 	set -e q[1]
	# 	# if value is a variable
	# 	if echo $k | grep '^\$' -q
	# 		# get the value
	# 		eval "set v $k"
	# 		# for each value..
	# 		for v in $v
	# 			# if it's a variable
	# 			if echo $v | grep '^\$' -q
	# 				# add it to the queue
	# 				set q $q $v
	# 			else
	# 				# add the key to the list
	# 				set list $list $k
	# 			end
	# 		end
	# 	else
	# 		# add the key to the list
	# 		set list $list $k
	# 	end
	# end
	# if test (count $list) -eq 0
	# 	err "No server(s) found for $servergroup"
	# 	return 1
	# end
	# echo $list
	# return 0
	# for server in $list
	# 	set name (echo $server | awk '{print substr($0,2)}')
	# 	eval "set address '$server'"
	# 	eval "$argv" "$name" "$address"
	# end
end
