# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.0g7IOI/bye.fish @ line 2
function bye
	if git is-git
		show cdg
		and show git co .
		and show git checkout master
		and show git fetch
		and show git rebase
		and show git co .
	end
	and exit $status
end
