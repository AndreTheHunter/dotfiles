function ci
	if command git is-git
		cljog circle-ci r --watch 5 --notify 1 --project (basename (pwd)) $argv;
	else
		cljog circle-ci r --watch 5 --notify 1 $argv;
	end
end
