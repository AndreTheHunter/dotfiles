# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.7DYX71/show.fish @ line 2
function show
	set -l cmd (string escape -- $argv)
	set_color yellow
	echo "$cmd"
	set_color normal
	$cmd
end
