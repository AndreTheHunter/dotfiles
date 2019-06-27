function subl-update-packages
	set -l packages ~/.config/sublime-text-3/Packages
	for dir in (ls $packages)
		set -l path (realpath $packages/$dir)
		if sush git -C $path status -s
			git -C $path pull
		end
	end
end
