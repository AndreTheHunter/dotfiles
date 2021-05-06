# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.UgWhrd/add_user_path.fish @ line 2
function add_user_path
		for path in $argv
			if test -d $path;and not contains $path $fish_user_paths
				set -g fish_user_paths $path $fish_user_paths
			end
		end
end
