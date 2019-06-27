function trim
	function do
		echo $argv|awk '$1=$1'
	end
	do-input $argv
end
