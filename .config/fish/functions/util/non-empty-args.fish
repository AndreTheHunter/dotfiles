set -l i 1
while test $i -le (count $argv)
	if test -z $argv[$i]
		set -e argv[$i]
	else
		set i (expr $i + 1)
	end
end
set -e i
if test (count $argv) -gt 0
	echo $argv
else
	echo -n \0
end
