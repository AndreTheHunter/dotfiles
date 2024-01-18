function cdg
	set --function toplevel (git rev-parse --show-cdup 2>/dev/null)
	if test $status -eq 0;and test -n $toplevel
		cd $toplevel
	end
end
