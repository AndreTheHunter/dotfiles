function is-executable-file
    set --local file $argv[1]
    test -f $file
    and test -x $file
end
