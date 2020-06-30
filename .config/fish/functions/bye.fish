function bye 
	if git is-git
		show git co .
  	and show git checkout master
  	and show git fetch
  	and show git rebase
  	and show git co .
	end
	and exit $status
end
