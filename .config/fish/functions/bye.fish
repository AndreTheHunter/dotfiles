# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.8gBNIi/bye.fish @ line 2
function bye
	if git is-git
		show cdg
		and show git co .
		and show git cor master
		and show git prune-merged
	end
	and exit $status
end
