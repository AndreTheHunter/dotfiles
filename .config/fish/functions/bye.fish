# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.wTlp4u/bye.fish @ line 2
function bye
	if git is-git
		show cdg
		and show git co .
		and show git checkout master
		and show git fetch
		and show git rebase
		and show git co .
		and show git prune-merged
	end
	and exit $status
end
