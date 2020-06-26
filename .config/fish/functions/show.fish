function show
	set -l cmd (string escape -- $argv)
	set_color yellow
	echo "$cmd"
	set_color normal
	$cmd
end
