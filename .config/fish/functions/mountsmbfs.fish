function mount_smbfs -a server
	if test $argv[1] = '--_completion'
		for-server $argv
		return 0
	end
	set util ~/.config/fish/functions/util
	source $util/mount.fish
	function _mount_smbfs -a name address
		mount $name "command mount_smbfs '//$address'"
	end
	for-server "$server" _mount_smbfs
end
