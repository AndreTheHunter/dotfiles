function forever
	if test (count $argv) -gt 0
		switch $argv[1]
			case 'status' 'st'
				command forever list
				# if forever list|grep -q $argv[2]
				# end
		end
	end
	command forever $argv
end
if sush which forever
else
	functions -e forever
end