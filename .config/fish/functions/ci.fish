function ci
	if command git is-git
		show cljog circle-ci recent --watch 10 --project (basename (pwd)) $argv;
	else
		show cljog circle-ci recent --watch 10 $argv;
	end
end
