function ci
	if command git is-git
		show cljog circle-ci recent --watch 10 --notify 1 --project (basename (pwd)) $argv;
	else
		show cljog circle-ci recent --watch 10 --notify 1 $argv;
	end
end
