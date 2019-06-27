function mountssh
	set -l host $arvg[1]
	set -l user $argv[2]
	mkdir -p "/Volumes/$1"

	sshfs remote_user_name@$1:/ "/Volumes/$1" -ovolname=$1
end

