# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.4L9YRO/ci.fish @ line 2
function ci
	if command git is-git
		cljog circle-ci r --watch 5 --project (basename (pwd)) $argv;
	else
		cljog circle-ci r --watch 5 $argv;
	end
end
