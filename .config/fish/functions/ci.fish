# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.lTqf86/ci.fish @ line 2
function ci
	if command git is-git
		cljog circle-ci r --watch 5 --notify 1 --project (basename (pwd)) $argv;
	else
		cljog circle-ci r --watch 5 --notify 1 $argv;
	end
end
