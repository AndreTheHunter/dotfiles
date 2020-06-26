# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.GzWQNE/watch-cmd.fish @ line 2
function watch-cmd
	clear
	$argv
	fswatch --print0 --one-per-batch . | xargs -0 -I {} -n 1 fish -c "clear;$argv"
end
