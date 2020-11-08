function bye
	if git is-git
		show cdg
		and show git co .
		and show git cor master
	end
	and exit $status
end
