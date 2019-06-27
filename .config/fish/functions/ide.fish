function ide
	set -l args
	if test (count $argv) -eq 0
		set args (pwd)
	else
		set args $argv
	end
	command /usr/local/opt/emacs-plus/bin/emacs $args &
end
