# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.SwUbiu/ci.fish @ line 1
function ci
	if command git is-git
		show cljog circle-ci recent --watch 10 --notify 1 --project (basename (pwd)) $argv;
	else
		show cljog circle-ci recent --watch 10 $argv;
	end
end
