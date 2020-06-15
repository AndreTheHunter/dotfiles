# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.u1LTPk/ci.fish @ line 2
function ci
	if command git is-git
		show cljog circle-ci recent \
		--watch 10 \
		--notify 1\
		--project (basename (pwd)) \
		--branch (git branch-name) \
		$argv;
	else
		show cljog circle-ci recent --watch 10 $argv;
	end
end
