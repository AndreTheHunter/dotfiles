function syb --description 'Start Ya Bastard'
	set --local retries  2
	set --local error_count 0
	while ! eval $argv;and test $error_count -lt $retries
		set error_count (math "$error_count+1")
	end
end
