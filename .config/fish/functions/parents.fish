function parents --description 'Print all parent directories of a path'
    set -l target $argv[1]
    if test -z "$target"
        set target $PWD
    end
    set -l path (string split -n / $target)
    while set -e path[-1]; and test (count $path) -gt 0
        echo /(string join / $path)
    end
    echo /
end
