function is-parent
    set --function parent (path resolve $argv[1])
    set --function path (path resolve $argv[2])
    if test $parent = $path
        return
    end
    string match --quiet (add-suffix '/' $parent)'*' (add-suffix '/' $path)
end
