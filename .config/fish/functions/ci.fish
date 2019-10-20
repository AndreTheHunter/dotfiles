function ci
	if command git is-git
		watch cljog circle-ci r --project (basename (pwd)) $argv;
	else
		watch cljog circle-ci r $argv;
	end
end
