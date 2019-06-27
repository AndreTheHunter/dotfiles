function escape -a str target escapeChar
	if test -z $str
		err Invalid number of argumnets
		return 1
	end
	if test -z $target
		set target '\\'
	end
	if test -z $escapeChar
		set escapeChar '\\'
	end
	set target (echo $target|sed "s|\\\\|\\\\\\\\\\\\\\\\|g")
	set escapeChar (echo $escapeChar|sed "s|\\\\|\\\\\\\\\\\\\\\\|g")
	echo $str|sed "s|$target|$escapeChar$target|g"
end
