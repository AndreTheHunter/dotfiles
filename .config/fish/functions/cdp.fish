function cdp
	if test (count $argv) -eq 0
		cd '..'
		return $status
	end
	if test $argv[1] = '--_completion'
		#TODO filter based on input
		parents
		return 0
	end
	#TODO match $argv to parent
	cd $argv
end
