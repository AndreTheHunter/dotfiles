#!/usr/bin/env fish
set --local tests (path resolve ./tests)
set --local result 0
set --local out (mktemp)
for test in (ls $tests/*.fish)
    set --local testname (grealpath --relative-to=$tests $test)
    fish --private --init-command='set -x fish_trace 1' $test >$out 2>&1
    if test $status -ne 0
        err $testname Failed:
        cat $out
        set result (math $result+1)
    else
        echo $testname Passed!
    end
    rm $out
end
exit $result
