#!/usr/bin/env fish
set tests (realpath ./tests)
set result 0
for test in (ls $tests/*.fish)
	set testname (realpath --relative-to=$tests $test)
	fish $test
	if test $status -ne 0
		err $testname Failed!
		set result (math $result+1)
	else
		echo $testname Passed
	end
end
exit $result
