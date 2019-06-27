function mount
	set name $argv[1]
	set -e argv[1]
	set mountpoint ~/mnt/$name
	if test -d $mountpoint
		umount $mountpoint
	else
		mkdir -p $mountpoint
	end
	set argv $argv $mountpoint
	if eval $argv
	else
		rmdir $mountpoint
		return 1
	end
end
