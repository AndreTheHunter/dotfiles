function mount_ssh -d 'Mounts the SSH servers in the specified server group' -a server
	if test $argv[1] = '--_completion'
		for-server $argv
		return 0
	end
	set util ~/.config/fish/functions/util
	source $util/mount.fish
	function _mount_ssh -a name address
		mount $name sshfs -s -o allow_root "'$address:/'"
	end
	for-server $server _mount_ssh
end
