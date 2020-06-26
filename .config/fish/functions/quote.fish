# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.VKZkSF/quote.fish @ line 2
function quote
	for arg in $argv
		# escape quotes
		set arg (string replace --all "'" "\'" $arg)
		set args $args "'$arg'"
	end
	if set -q args
		echo "$args"
	end
	return 0
end
