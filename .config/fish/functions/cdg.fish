function cdg
	set toplevel (command git rev-parse --show-toplevel 2>/dev/null)
	if test -n $toplevel
		cd $toplevel
	end
end
