function umount-remote
	set mounts ~/mnt
	for mnt in (ls $mounts)
		set mnt $mounts/$mnt
		umount $mnt
		rmdir $mnt
	end
end
