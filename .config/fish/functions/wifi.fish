function wifi
	if test ! (functions -q _wifi)
		function _wifi
			networksetup -setairportpower en0 $argv
		end
	end
	if test (count $argv) -eq 0
		networksetup -getairportpower en0 | ag --nocolor --only-matching '([[:alnum:]]+)$'
	else
		switch $argv
			case on start
				_wifi on
			case off stop
				_wifi off
			case reset restart
				_wifi off
				_wifi on
			case toggle
				if test wifi = Off
					wifi on
				else
					wifi off
				end
		end
	end
end
