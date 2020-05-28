function watch-cmd
	$argv
	fswatch --print0 --one-per-batch . | xargs -0 -I {} -n 1 fish -c "$argv"
end
