# Defined in /var/folders/xt/l66l0pyj6n3gzm89h072z8_m0000gn/T//fish.nrucT4/bye.fish @ line 1
function bye --wraps='git checkout master;and git u;and exit'
	if git is-git
  	git checkout master
  	and git u
  	and git checkout .
	end
  exit $argv
end
