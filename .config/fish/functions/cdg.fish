function cdg
	set toplevel (command git rev-parse --show-toplevel ^/dev/null)
	if test -n $toplevel
		cd $toplevel
	end
end
