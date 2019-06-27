function ssh-to -a server cmd
	if test $argv[1] = '--_completion'
		for-server $argv
		return 0
	end
	function _ssh -a name address
		echo $name $address
		#TODO support sending remote commands and
		#TODO either fix newtab or use byobu/tmux
		newtab ssh $address
	end
	for-server $server _ssh
end
