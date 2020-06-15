# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.p8Oefd/watch-cmd.fish @ line 2
function watch-cmd
	$argv
	fswatch --print0 --one-per-batch . | xargs -0 -I {} -n 1 fish -c "$argv"
end
