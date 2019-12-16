function ci
	if command git is-git
		show cljog circle-ci r --watch 5 --notify 1 --project (basename (pwd)) $argv;
	else
		show cljog circle-ci r --watch 5 --notify 1 $argv;
	end
end
